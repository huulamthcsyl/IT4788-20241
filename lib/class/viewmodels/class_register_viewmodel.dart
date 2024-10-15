import '../models/class_model.dart';
import 'package:flutter/material.dart';

class ClassRegisterViewModel extends ChangeNotifier {
  List<ClassInfo> registeredClasses = [];

  // Hàm để thêm lớp vào danh sách
  void addClass(String classCode) {
    if (classCode.isNotEmpty) {
      registeredClasses.add(
        ClassInfo(
          classCode: classCode,
          linkedClassCode: 'MLK01', // ví dụ dữ liệu
          courseCode: 'MHP01',
          className: 'Toán Cao Cấp',
          schedule: 'Thứ 2, Tiết 3-5',
          classroom: 'Phòng 101',
          credits: 3,
          classType: 'Lý thuyết',
          status: 'Chờ xử lý',
        ),
      );
      notifyListeners();
    }
  }

  // Hàm để gửi đăng ký, cập nhật trạng thái các lớp thành "Thành công"
  void submitRegistration() {
    for (var classInfo in registeredClasses) {
      classInfo.status = 'Thành công';
    }
    notifyListeners();
  }

  // Hàm để xóa các lớp đã chọn khỏi danh sách
  void deleteSelectedClasses() {
    registeredClasses.removeWhere((classInfo) => classInfo.isSelected);
    notifyListeners();
  }

  // Hàm để đánh dấu lớp đã chọn
  void toggleClassSelection(int index, bool? value) {
    registeredClasses[index].isSelected = value ?? false;
    notifyListeners();
  }
}
