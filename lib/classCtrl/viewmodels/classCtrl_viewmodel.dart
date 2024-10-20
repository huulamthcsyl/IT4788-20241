import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class ClassCtrlViewModel extends ChangeNotifier {
  List<ClassData> _classes = [
    ClassData(
      classId: '001',
      classCode: 'A1',
      linkedClassCode: 'A2',
      courseCode: 'C001',
      className: 'Lớp 1A',
      schedule: 'Thứ 2: 8h - 10h',
      classroom: 'Phòng 101',
      credits: 3,
      classType: 'Thường',
      status: 'Đang hoạt động',
      maxStudents: 30,
      students: [
        Student('Nguyễn Văn A'),
        Student('Trần Thị B'),
        Student('Lê Văn C'),
      ],
    ),
    // Example of additional classes
    ClassData(
      classId: '002',
      classCode: 'B1',
      linkedClassCode: 'B2',
      courseCode: 'C002',
      className: 'Lớp 1B',
      schedule: 'Thứ 3: 10h - 12h',
      classroom: 'Phòng 102',
      credits: 4,
      classType: 'Thực hành',
      status: 'Đang hoạt động',
      maxStudents: 25,
      students: [
        Student('Nguyễn Văn D'),
        Student('Trần Thị E'),
      ],
    ),
    ClassData(
      classId: '003',
      classCode: 'C1',
      linkedClassCode: 'C2',
      courseCode: 'C003',
      className: 'Lớp 1C',
      schedule: 'Thứ 5: 14h - 16h',
      classroom: 'Phòng 103',
      credits: 2,
      classType: 'Lý thuyết',
      status: 'Đã kết thúc',
      maxStudents: 20,
      students: [
        Student('Lê Văn F'),
        Student('Nguyễn Thị G'),
      ],
    ),
  ];

  List<ClassData> get classes => _classes;

  // Add a new class
  void addClass(ClassData newClass) {
    _classes.add(newClass);
    notifyListeners();
  }

  // Edit an existing class
  void editClass(int index, ClassData updatedClass) {
    if (index >= 0 && index < _classes.length) {
      _classes[index] = updatedClass;
      notifyListeners();
    }
  }

  // Delete a class
  void deleteClass(int index) {
    if (index >= 0 && index < _classes.length) {
      _classes.removeAt(index);
      notifyListeners();
    }
  }

  // Search for classes by name
  List<ClassData> searchClasses(String query) {
    if (query.isEmpty) {
      return _classes;
    }
    return _classes.where((classData) =>
        classData.className.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}