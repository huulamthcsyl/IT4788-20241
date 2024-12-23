import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:provider/provider.dart';
import '../../utils/show_notification.dart';

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
    _setLoading(true);
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
        showNotification('Tải danh sách lớp thành công!', Colors.green);
      } else {
        _hasMore = false;
      }
    } catch (error) {
      _errorMessage = 'Không thể tải danh sách lớp: $error';
      showNotification(_errorMessage!,  Colors.red);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (value) {
      _isLoading = true;
      notifyListeners();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        _isLoading = false;
        notifyListeners();
      });
    }
  }

  void addClass(ClassData newClass) {
    _classes.add(newClass);
    notifyListeners();
  }

  Future<void> editClass(int index, ClassData updatedClass) async {
    try {
      final success = await _apiService.editClassDetails(updatedClass);
      if (success) {
        _classes[index] = updatedClass;
        showNotification('Cập nhật lớp thành công!', Colors.green);
        notifyListeners();
      } else {
        _errorMessage = 'Không thể cập nhật lớp';
        showNotification(_errorMessage!,  Colors.red);
      }
    } catch (error) {
      _errorMessage = 'Không thể cập nhật lớp: $error';
      showNotification(_errorMessage!,  Colors.red);
      notifyListeners();
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      final success = await _apiService.deleteClass(classId);
      if (success) {
        _classes.removeWhere((classData) => classData.classId == classId);
        showNotification('Lớp học đã được xóa thành công!', Colors.green);
      } else {
        _errorMessage = 'Không thể xóa lớp';
        showNotification(_errorMessage!, Colors.red);
      }
    } catch (error) {
      _errorMessage = 'Không thể xóa lớp: $error';
      showNotification(_errorMessage!, Colors.red);
    }
    // Reload the class list after the deletion attempt, regardless of success/failure

    notifyListeners();  // Notify listeners to update the UI with the new class list
  }


  ClassData saveClass() {
    return ClassData(
      classId: classId,
      classCode: classCode,
      className: name,
      startDate: startDate,
      endDate: endDate,
      maxStudents: maxStudents,
      classType: classType,
      status: status,
      studentAccounts: [],
    );
  }

  Future<void> updateClass(ClassData classData) async {
    try {
      final success = await _apiService.editClassDetails(classData);
      if (success) {
        showNotification('Cập nhật lớp thành công!',  Colors.green);
        notifyListeners();
      } else {
        showNotification('Không thể cập nhật lớp.',  Colors.red);
      }
    } catch (e) {
      showNotification('Lỗi khi cập nhật lớp: $e',  Colors.red);
    }
    await fetchClasses();
  }

  Future<void> getStudentListForClass(String classId) async {
    _setLoading(true);
    try {
      final response = await _apiService.getClassInfo(classId: classId);

      if (response != null) {
        List<Student> studentList = (response['student_accounts'] as List<dynamic>? ?? [])
            .map((studentJson) => Student.fromJson(studentJson))
            .toList();

        final classIndex = _classes.indexWhere((classData) => classData.classId == classId);

        if (classIndex != -1) {
          _classes[classIndex].studentAccounts = studentList;
          _errorMessage = null;
          showNotification('Tải danh sách sinh viên thành công!',  Colors.green);
        } else {
          _errorMessage = 'Lớp không tồn tại.';
          showNotification(_errorMessage!,  Colors.red);
        }
      } else {
        _errorMessage = 'Không thể tải danh sách sinh viên.';
        showNotification(_errorMessage!,  Colors.red);
      }
    } catch (error) {
      _errorMessage = 'Lỗi khi tải danh sách sinh viên: $error';
      showNotification(_errorMessage!,  Colors.red);
    } finally {
      _setLoading(false);
    }
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
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await viewModel.deleteClass(classId);
                //context.read<ClassCtrlViewModel>().fetchClasses();
                await fetchClasses();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
