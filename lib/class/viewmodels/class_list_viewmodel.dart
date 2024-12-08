import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../repositories/class_repository.dart';

class ClassListViewModel extends ChangeNotifier {
  final ClassRepository _classRepository = ClassRepository();
  late List<ClassInfo> _originalClasses;
  List<ClassInfo> _classes = [];
  List<ClassInfo> get classes => _classes;

  int _currentPage = 0;
  final int _rowsPerPage = 20;

  int get currentPage => _currentPage;

  ClassListViewModel() {
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      _originalClasses = await _classRepository.getOpenClasses();
      _classes = List.from(_originalClasses);
      notifyListeners();
    } catch (e) {
      // Handle API error (e.g., show a toast)
      print(e);
    }
  }

  void searchClasses(String code) {
    if (code.isEmpty) {
      _classes = List.from(_originalClasses);
    } else {
      _classes = _originalClasses.where((classItem) {
        return classItem.class_id.contains(code);
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

  Future<void> showClassDetails(BuildContext context, ClassInfo classInfo) async {
    try {
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
                  Text('Mã lớp: ${classInfo.class_id}'),
                  Text('Mã lớp kèm: ${classInfo.attached_code}'),
                  Text('Tên lớp: ${classInfo.class_name}'),
                  Text('Giảng viên: ${classInfo.lecturer_name}'),
                  Text('Số lượng SV: ${classInfo.student_count}'),
                  Text('Ngày bắt đầu: ${classInfo.start_date}'),
                  Text('Ngày kết thúc: ${classInfo.end_date}'),
                  Text('Loại lớp: ${classInfo.class_type}'),
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
    } catch (e) {
      // Handle error (e.g., show a toast)
      print(e);
    }
  }
}
