import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassListViewModel extends ChangeNotifier {
  late List<ClassInfo> _classes;
  List<ClassInfo> filteredClasses = [];

  ClassListViewModel() {
    _classes = _fetchClasses(); // Load dữ liệu giả lập hoặc từ CSDL
  }

  List<ClassInfo> get classes => _classes;

  // Hàm giả lập để lấy dữ liệu, thay bằng gọi đến CSDL nếu có
  List<ClassInfo> _fetchClasses() {
    return List.generate(100, (index) => ClassInfo(
      classCode: '${index + 1}',
      linkedClassCode: '${index + 1}',
      courseCode: 'IT${index + 1}',
      className: 'Môn ${index + 1}',
      schedule: '06:45-10:05 T3',
      classroom: 'TC-${index + 1}',
      credits: 3,
      classType: 'LT+BT',
      status: 'Đang mở',
    ));
  }

  void searchClasses(String code) {
    // Lọc danh sách lớp học theo mã học phần
    filteredClasses = classes.where((classModel) => classModel.courseCode == code).toList();
    notifyListeners();
  }
}
