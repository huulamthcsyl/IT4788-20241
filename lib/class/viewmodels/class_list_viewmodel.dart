import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassListViewModel extends ChangeNotifier {
  late List<ClassInfo> _originalClasses;
  List<ClassInfo> _classes = [];
  List<ClassInfo> get classes => _classes;

  int _currentPage = 0;
  final int _rowsPerPage = 20;

  int get currentPage => _currentPage;

  ClassListViewModel() {
    _originalClasses = _fetchClasses();
    _classes = List.from(_originalClasses);
  }

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
    if (code.isEmpty) {
      _classes = List.from(_originalClasses);
    } else {
      _classes = _originalClasses.where((classItem) {
        return classItem.courseCode.contains(code) || classItem.classCode.contains(code);
      }).toList();
    }
    _currentPage = 0; // Reset page when searching
    notifyListeners();
  }

  List<ClassInfo> getDisplayedClasses() {
    final int start = _currentPage * _rowsPerPage;
    final int end = start + _rowsPerPage > _classes.length ? _classes.length : start + _rowsPerPage;
    return _classes.sublist(start, end);
  }

  bool get canGoBack => _currentPage > 0;
  bool get canGoForward => (_currentPage + 1) * _rowsPerPage < _classes.length;

  void previousPage() {
    if (canGoBack) {
      _currentPage--;
      notifyListeners();
    }
  }

  void nextPage() {
    if (canGoForward) {
      _currentPage++;
      notifyListeners();
    }
  }

  void showClassDetails(BuildContext context, ClassInfo classInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Chi tiết lớp học', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 16),
                Text('Mã lớp: ${classInfo.classCode}'),
                Text('Mã lớp kèm: ${classInfo.linkedClassCode}'),
                Text('Mã học phần: ${classInfo.courseCode}'),
                Text('Tên lớp: ${classInfo.className}'),
                Text('Lịch học: ${classInfo.schedule}'),
                Text('Phòng học: ${classInfo.classroom}'),
                Text('Số tín chỉ: ${classInfo.credits}'),
                Text('Loại lớp: ${classInfo.classType}'),
                Text('Trạng thái: ${classInfo.status}'),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Đóng', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
