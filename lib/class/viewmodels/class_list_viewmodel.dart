import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../repositories/class_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import '../../auth/models/user_data.dart';

class ClassListViewModel extends ChangeNotifier {
  final ClassRepository _classRepository = ClassRepository();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;
  late List<ClassInfo> _originalClasses;
  List<ClassInfo> _classes = [];
  List<ClassInfo> get classes => _classes;
  int _currentPage = 0;
  final int _rowsPerPage = 20;
  int get currentPage => _currentPage;

  UserData userData = UserData(
    id: '',
    ho: '',
    ten: '',
    name: '',
    email: '',
    token: '',
    status: '',
    role: '',
    avatar: '',
  );

  ClassListViewModel() {
    _init();
  }

  void _init() async {
    await initUserData();
    if (userData.token != null) {
      await fetchClasses();
    }
  }

  Future<void> initUserData() async {
    try {
      userData = await getUserData();
      notifyListeners();
      print("userData.token: ${userData.token}");
    } catch (e) {
      print("Error initializing user data: $e");
    }
  }

  Future<void> fetchClasses() async {
    try {
      if (userData.token == null) {
        print("Token is empty. Cannot fetch classes.");
        return;
      }
      print("Fetching classes with token: ${userData.token}");
      _originalClasses = await _classRepository.getOpenClasses(userData.token);
      _classes = List.from(_originalClasses);
      notifyListeners();
    } catch (e) {
      print("Error fetching classes: $e");
    }
  }

  void searchClasses(String code) {
    if (code.isEmpty) {
      _classes = List.from(_originalClasses);
    } else {
      _classes = _originalClasses.where((classItem) {
        return classItem.class_id.contains(code) || classItem.class_name.contains(code);
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

}
