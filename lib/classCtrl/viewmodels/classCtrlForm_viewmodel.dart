import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import '../../utils/show_notification.dart';

class ClassCtrlFormViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService(); // Khởi tạo API service
  String classId = '';
  String attachedCode = '';
  String name = '';
  String startDate = '';
  String endDate = '';
  String classType = '';
  int maxStudents = 0;

  // Phương thức tạo lớp
  Future<void> createClass(ClassData classData) async {
    try {
      final response = await _apiService.createClass(classData); // Gọi API tạo lớp
      print(response);
      if (response != null && response['meta']['code'] == '1000') {
        // Nếu mã phản hồi là 1000, có nghĩa là tạo lớp thành công
        showNotification('Tạo lớp học thành công!',  Colors.green);
        notifyListeners();
      } else {
        // Nếu API trả về lỗi hoặc mã không phải 1000, xử lý lỗi
        final errorMessage = response?['meta']['message'] ?? 'Lỗi không xác định';
        showNotification('Không thể tạo lớp: $errorMessage',  Colors.red);
      }
    } catch (e) {
      // Xử lý ngoại lệ nếu có lỗi khi gọi API
      showNotification('Lỗi khi tạo lớp: $e',  Colors.red);
    }
  }

  // Phương thức lưu lớp
  ClassData saveClass() {
    return ClassData(
      classId: classId,
      classCode: attachedCode,
      className: name,
      startDate: startDate,
      endDate: endDate,
      classType: classType,
      maxStudents: maxStudents,
      status: 'Active', // Trạng thái mặc định
      studentAccounts: [], // Chưa có sinh viên
    );
  }

  void onSave(ClassData newClass) {}

  void reset() {
    classId = '';
    attachedCode = '';
    name = '';
    startDate = '';
    endDate = '';
    classType = '';
    maxStudents = 0;
  }
}
