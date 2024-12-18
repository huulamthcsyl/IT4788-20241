import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

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

      // Kiểm tra xem response có hợp lệ và không rỗng
      if (response != null && response['meta']['code'] == '1000') {
        // Nếu mã phản hồi là 1000, có nghĩa là tạo lớp thành công
        final classResponse = response['data'];

        // Tạo một đối tượng ClassData từ phản hồi
        final newClass = ClassData(
          classId: classResponse['class_id'],
          classCode: classResponse['class_id'],  // Sử dụng class_id cho classCode nếu cần
          className: classResponse['class_name'],
          startDate: classResponse['start_date'],
          endDate: classResponse['end_date'],
          classType: classResponse['class_type'],
          maxStudents: int.tryParse(classResponse['max_student_amount'] ?? '0') ?? 0,
          status: classResponse['status'],
          studentAccounts: [], // Giả sử không có sinh viên khi tạo mới lớp
        );

        // Cập nhật UI hoặc xử lý theo nhu cầu, có thể thông báo thành công hoặc quay lại trang trước
        onSave(newClass);  // Nếu cần truyền ClassData về giao diện chính
      } else {
        // Nếu API trả về lỗi hoặc mã không phải 1000, xử lý lỗi
        print('Failed to create class: ${response?['meta']['message']}');
      }
    } catch (e) {
      print('Error creating class: $e');
      // Xử lý ngoại lệ nếu có lỗi khi gọi API
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
