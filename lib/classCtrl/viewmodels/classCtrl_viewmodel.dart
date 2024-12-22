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

  // Fetch classes from API with pagination
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
    }
  }

  // Set the loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
    List<Student>? studentList = null; // Initialize studentList as null initially

    try {
      // Call the API to get class info including students
      final response = await _apiService.getClassInfo(classId: classId);

      if (response != null) {
        // Extract student list from the response if available
        studentList = (response['student_accounts'] as List<dynamic>?)
            ?.map((studentJson) => Student.fromJson(studentJson))
            .toList() ?? [];

        // Find the class index in the list
        final classIndex = _classes.indexWhere((classData) => classData.classId == classId);

        if (classIndex != -1) {
          // Directly update the studentAccounts of the class without using copyWith
          _classes[classIndex].studentAccounts = studentList;
        }
        _errorMessage = null;
      } else {
        _errorMessage = 'Không thể tải danh sách sinh viên.';
      }
    } catch (error) {
      _errorMessage = 'Lỗi khi tải danh sách sinh viên: $error';
    } finally {
      _setLoading(false);
    }
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
                Navigator.pop(context); // Đóng hộp thoại
                // Gọi phương thức xóa lớp
                await viewModel.deleteClass(classId);

                if (viewModel.errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lớp học đã được xóa thành công!')),
                  );
                  // Làm mới danh sách lớp
                  context.read<ClassCtrlViewModel>().fetchClasses();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.errorMessage!)),
                  );
                }
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
