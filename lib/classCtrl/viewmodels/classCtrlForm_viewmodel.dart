import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class ClassCtrlFormViewModel extends ChangeNotifier {
  // Các biến để lưu thông tin lớp
  String _classId = '';
  String _classCode = '';
  String _linkedClassCode = ''; // Added for linked class code
  String _courseCode = ''; // Added for course code
  String _name = '';
  String _schedule = ''; // Added for schedule
  String _classroom = ''; // Added for classroom
  int _credits = 0; // Added for credits
  String _classType = ''; // Added for class type
  String _status = ''; // Added for status
  int _maxStudents = 0;
  List<Student> studentList = [];

  // Danh sách các lớp
  List<ClassData> _classes = []; // Danh sách lớp hiện tại

  // Getter và Setter cho mã lớp
  String get classId => _classId;
  set classId(String value) {
    _classId = value;
    notifyListeners();
  }

  // Getter và Setter cho mã lớp kèm
  String get classCode => _classCode;
  set classCode(String value) {
    _classCode = value;
    notifyListeners();
  }

  // Getter và Setter cho mã lớp liên kết
  String get linkedClassCode => _linkedClassCode;
  set linkedClassCode(String value) {
    _linkedClassCode = value;
    notifyListeners();
  }

  // Getter và Setter cho mã khóa học
  String get courseCode => _courseCode;
  set courseCode(String value) {
    _courseCode = value;
    notifyListeners();
  }

  // Getter và Setter cho tên lớp
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  // Getter và Setter cho lịch học
  String get schedule => _schedule;
  set schedule(String value) {
    _schedule = value;
    notifyListeners();
  }

  // Getter và Setter cho phòng học
  String get classroom => _classroom;
  set classroom(String value) {
    _classroom = value;
    notifyListeners();
  }

  // Getter và Setter cho số tín chỉ
  int get credits => _credits;
  set credits(int value) {
    _credits = value;
    notifyListeners();
  }

  // Getter và Setter cho loại lớp
  String get classType => _classType;
  set classType(String value) {
    _classType = value;
    notifyListeners();
  }

  // Getter và Setter cho trạng thái
  String get status => _status;
  set status(String value) {
    _status = value;
    notifyListeners();
  }

  // Getter và Setter cho số lượng học sinh tối đa
  int get maxStudents => _maxStudents;
  set maxStudents(int value) {
    _maxStudents = value;
    notifyListeners();
  }

  // Phương thức để lưu thông tin lớp
  ClassData saveClass() {
    return ClassData(
      classId: _classId,
      classCode: _classCode,
      linkedClassCode: _linkedClassCode,
      courseCode: _courseCode,
      className: _name,
      schedule: _schedule,
      classroom: _classroom,
      credits: _credits,
      classType: _classType,
      status: _status,
      maxStudents: _maxStudents,
      students: studentList,
    );
  }

  // Xóa một lớp theo chỉ số
  void deleteClass(int index) {
    if (index >= 0 && index < _classes.length) {
      _classes.removeAt(index);
      notifyListeners();
    }
  }

  // Thêm lớp mới vào danh sách
  void addClass(ClassData newClass) {
    _classes.add(newClass);
    notifyListeners();
  }
}