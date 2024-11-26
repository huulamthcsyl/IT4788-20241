import '../models/class_model.dart';
import 'package:flutter/material.dart';
import '../repositories/class_repository.dart';

class ClassRegisterViewModel extends ChangeNotifier {
  List<ClassInfo> registeredClasses = [];
  List<ClassInfo> tempDeletedClasses = [];// Danh sách lưu các lớp bị xóa tạm thời
  final ClassRepository _repository = ClassRepository();

  // Hàm thêm lớp thông qua API
  Future<void> addClass(String classCode) async {
    if (classCode.isNotEmpty) {
      try {
        ClassInfo classInfo = await _repository.getClassInfo(classCode);
        registeredClasses.add(classInfo);
        notifyListeners();
      } catch (e) {
        print("Lỗi khi lấy thông tin lớp học: $e");
      }
    }
  }

  // Gửi danh sách đăng ký lớp
  Future<void> submitRegistration() async {
    try {
      for (var classInfo in registeredClasses) {
        await _repository.registerClass(classInfo.classCode);
        classInfo.status = 'Thành công';
      }
      tempDeletedClasses.clear();
      notifyListeners();
    } catch (e) {
      print("Lỗi khi gửi đăng ký lớp học: $e");
    }
  }

  // Xóa tạm thời
  void deleteClassTemporarily(int index) {
    tempDeletedClasses.add(registeredClasses[index]);
    registeredClasses.removeAt(index);
    notifyListeners();
  }
}
