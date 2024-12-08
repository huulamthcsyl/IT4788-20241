import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class ClassCtrlViewModel extends ChangeNotifier {
  final _apiService = ApiService(userData: UserData()); // API service instance

  String classId = '';
  String classCode = '';
  String name = '';
  String startDate = '';
  String endDate = '';
  String classType = '';
  int maxStudents = 0;

  List<ClassData> _classes = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 0;
  final int _pageSize = 7;
  bool _hasMore = true;

  List<ClassData> get classes => _classes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // Load more classes when user scrolls to bottom
  Future<void> loadMoreClasses() async {
    if (_isLoading || !_hasMore) return;
    await fetchClasses(page: _currentPage + 1); // Load next page
  }

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
        _currentPage = page;
        _errorMessage = null;
      } else {
        _hasMore = false;
      }
    } catch (error) {
      _errorMessage = 'Không thể tải danh sách lớp: $error';
    } finally {
      _setLoading(false);
    }
  }

  // Set the loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Search for classes by class name or class ID
  List<ClassData> searchClasses(String searchQuery) {
    if (searchQuery.isEmpty) {
      return _classes;
    }
    return _classes
        .where((classData) =>
    classData.className.toLowerCase().contains(searchQuery.toLowerCase()) ||
        classData.classId.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  // Add a new class to the list
  void addClass(ClassData newClass) {
    _classes.add(newClass);
    notifyListeners();
  }

  // Edit class details and update via API
  Future<void> editClass(int index, ClassData updatedClass) async {
    try {
      // Call API to update class
      final success = await _apiService.editClassDetails(updatedClass);
      if (success) {
        // Update the class locally if the API call is successful
        _classes[index] = updatedClass;
        notifyListeners(); // Notify listeners to update the UI
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
      classType: classType,
      maxStudents: maxStudents,
      status: 'Active', // Trạng thái mặc định
      studentAccounts: [], // Chưa có sinh viên
    );
  }

  // Phương thức cập nhật lớp
  Future<void> updateClass(ClassData classData) async {
    try {
      final success = await _apiService.editClassDetails(classData);  // Gọi API cập nhật lớp
      if (success) {
        // Nếu cập nhật thành công, thông báo hoặc cập nhật UI
        notifyListeners();  // Thông báo rằng có sự thay đổi
      } else {
        print('Failed to update class');
      }
    } catch (e) {
      print('Error updating class: $e');
    }
  }

}