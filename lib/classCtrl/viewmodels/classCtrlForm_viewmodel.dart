import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class ClassCtrlFormViewModel extends ChangeNotifier {
  // Các biến để lưu thông tin lớp
  String _name = '';
  int _studentCount = 0;

  // Getter và Setter cho tên lớp
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners(); // Thông báo cho giao diện biết có sự thay đổi
  }

  // Getter và Setter cho số lượng sinh viên
  int get studentCount => _studentCount;
  set studentCount(int value) {
    _studentCount = value;
    notifyListeners(); // Thông báo cho giao diện biết có sự thay đổi
  }

  // Phương thức để lưu thông tin lớp
  ClassData saveClass() {
    return ClassData(_name, _studentCount);
  }
}