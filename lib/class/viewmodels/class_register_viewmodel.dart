import '../models/class_model.dart';
import 'package:flutter/material.dart';

class ClassRegisterViewModel extends ChangeNotifier {
  List<ClassInfo> registeredClasses = [];
  List<ClassInfo> tempDeletedClasses = []; // Danh sách lưu các lớp bị xóa tạm thời

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

  // Hàm để gửi đăng ký, xóa hẳn các lớp trong tempDeletedClasses
  void submitRegistration() {
    // Gọi API hoặc thao tác xóa trong cơ sở dữ liệu tại đây
    tempDeletedClasses.clear(); // Xóa tempDeletedClasses sau khi gửi đăng ký
    for (var classInfo in registeredClasses) {
      classInfo.status = 'Thành công';
    }
    notifyListeners();
  }

  // Hàm để xóa tạm thời các lớp khỏi danh sách hiển thị (nhưng chưa xóa hẳn)
  void deleteClassTemporarily(int index) {
    tempDeletedClasses.add(registeredClasses[index]);
    registeredClasses.removeAt(index);
    notifyListeners();
  }
}
