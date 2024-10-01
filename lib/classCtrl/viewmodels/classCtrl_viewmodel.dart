import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class ClassCtrlViewModel extends ChangeNotifier {
  // Danh sách lớp
  List<ClassData> _classes = [
    ClassData('Lớp 1A', 30),
    ClassData('Lớp 2B', 25),
    ClassData('Lớp 3C', 20),
    ClassData('Lớp 4D', 15),
    ClassData('Lớp 5E', 10),
  ];

  List<ClassData> get classes => _classes;

  // Thêm lớp mới
  void addClass(ClassData newClass) {
    _classes.add(newClass);
    notifyListeners(); // Thông báo cho giao diện
  }

  // Sửa lớp
  void editClass(int index, ClassData updatedClass) {
    if (index >= 0 && index < _classes.length) {
      _classes[index] = updatedClass;
      notifyListeners(); // Thông báo cho giao diện
    }
  }

  // Xóa lớp
  void deleteClass(int index) {
    if (index >= 0 && index < _classes.length) {
      _classes.removeAt(index);
      notifyListeners(); // Thông báo cho giao diện
    }
  }
}