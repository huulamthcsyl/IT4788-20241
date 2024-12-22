import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:provider/provider.dart';

class ClassCtrlViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService(); // API service instance

  String classId = '';
  String classCode = '';
  String name = '';
  String? startDate;
  String? endDate;
  int maxStudents = 0;
  String classType = '';
  String status = 'Active'; // Default status for the class

  List<ClassData> _classes = [];
  bool _isLoading = false;
  String? _errorMessage;
  final int _pageSize = 25;
  bool _hasMore = true;

  List<ClassData> get classes => _classes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  Future<void> fetchClasses({int page = 0}) async {
    _setLoading(true); // Start loading data
    try {
      final response = await _apiService.getClassList(
        page: page,
        pageSize: _pageSize,
      );

      if (response != null && response.isNotEmpty) {
        final newClasses = response.map((data) => ClassData.fromJson(data)).toList();

        if (page == 0) {
          _classes = newClasses;
        } else {
          _classes.addAll(newClasses);
        }

        _hasMore = response.length == _pageSize;
        _errorMessage = null;
      } else {
        _hasMore = false;
      }
    } catch (error) {
      _errorMessage = 'Không thể tải danh sách lớp: $error';
    } finally {
      _setLoading(false); // Ensure loading state is stopped after data is loaded
    }
  }

  // Set the loading state and notify listeners
  void _setLoading(bool value) {
    // Đảm bảo rằng việc thay đổi trạng thái loading không kéo dài quá lâu
    if (value) {
      // Chỉ thay đổi trạng thái khi bắt đầu gọi API
      _isLoading = true;
      notifyListeners();
    } else {
      // Đảm bảo không để trạng thái loading lâu, cập nhật lại trạng thái ngay sau khi có kết quả
      Future.delayed(const Duration(milliseconds: 200), () {
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  // Add a new class to the list
  void addClass(ClassData newClass) {
    _classes.add(newClass);
    notifyListeners();
  }

  // Edit class details and update via API
  Future<void> editClass(int index, ClassData updatedClass) async {
    try {
      final success = await _apiService.editClassDetails(updatedClass);
      if (success) {
        _classes[index] = updatedClass;
        notifyListeners();
      } else {
        _errorMessage = 'Không thể cập nhật lớp';
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = 'Không thể cập nhật lớp: $error';
      notifyListeners();
    }
  }

  // Delete class
  Future<void> deleteClass(String classId) async {
    try {
      final success = await _apiService.deleteClass(classId);
      if (success) {
        _classes.removeWhere((classData) => classData.classId == classId);
        notifyListeners();
      } else {
        _errorMessage = 'Không thể xóa lớp';
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = 'Không thể xóa lớp: $error';
      notifyListeners();
    }
  }

  // Phương thức lưu lớp
  ClassData saveClass() {
    return ClassData(
      classId: classId,
      classCode: classCode,
      className: name,
      startDate: startDate,
      endDate: endDate,
      maxStudents: maxStudents,
      classType: classType,
      status: status,  // Trạng thái mặc định là 'Active'
      studentAccounts: [], // Chưa có sinh viên
    );
  }

  // Phương thức cập nhật lớp
  Future<void> updateClass(ClassData classData) async {
    try {
      final success = await _apiService.editClassDetails(classData);
      if (success) {
        notifyListeners();
      } else {
        print('Failed to update class');
      }
    } catch (e) {
      print('Error updating class: $e');
    }
  }

  // Fetch student list for a specific class
  Future<void> getStudentListForClass(String classId) async {
    _setLoading(true); // Start loading

    try {
      // Gọi API để lấy thông tin lớp, bao gồm cả danh sách sinh viên
      final response = await _apiService.getClassInfo(classId: classId);

      if (response != null) {
        // Lấy danh sách sinh viên từ response (nếu có)
        List<Student> studentList = (response['student_accounts'] as List<dynamic>? ?? [])
            .map((studentJson) => Student.fromJson(studentJson))
            .toList();

        // Tìm vị trí lớp trong danh sách lớp
        final classIndex = _classes.indexWhere((classData) => classData.classId == classId);

        if (classIndex != -1) {
          // Cập nhật danh sách sinh viên của lớp mà không sử dụng copyWith
          _classes[classIndex].studentAccounts = studentList;
          _errorMessage = null;
        } else {
          _errorMessage = 'Lớp không tồn tại.';
        }
      } else {
        _errorMessage = 'Không thể tải danh sách sinh viên.';
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      _errorMessage = 'Lỗi khi tải danh sách sinh viên: $error';
    } finally {
      _setLoading(false); // Đảm bảo trạng thái loading được dừng lại khi hoàn tất
    }

    // Notify listeners để giao diện cập nhật
    notifyListeners();
  }

  void showDeleteConfirmationDialog(BuildContext context, String classId, ClassCtrlViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa lớp'),
          content: const Text('Bạn có chắc chắn muốn xóa lớp này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Đóng hộp thoại trước khi thực hiện hành động xóa

                // Gọi phương thức xóa lớp
                await viewModel.deleteClass(classId);

                // Thông báo kết quả
                String message = viewModel.errorMessage == null
                    ? 'Lớp học đã được xóa thành công!'
                    : viewModel.errorMessage!;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );

                // Luôn làm mới danh sách lớp, ngay cả khi xóa không thành công
                context.read<ClassCtrlViewModel>().fetchClasses();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

}
