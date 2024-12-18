import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../repositories/class_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import '../../auth/models/user_data.dart';

class ClassStudentViewModel with ChangeNotifier {
  final ClassRepository _classRepository = ClassRepository();

  List<ClassInfo> registeredClasses = [];
  List<ClassInfo> newClasses = [];
  List<String> newClassIds = [];

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

  ClassStudentViewModel() {
    _init();
  }

  void _init() async {
    await initUserData();
    if (userData.token != null) {
      await fetchRegisteredClasses();
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

  Future<void> fetchRegisteredClasses() async {
    try {
      if (userData.token == null) {
        print("Token is empty. Cannot fetch classes.");
        return;
      }
      print("Fetching classes with token: ${userData.token}");
      registeredClasses = await _classRepository.getClassList(userData.token, userData.id);
      notifyListeners();
    } catch (e) {
      print("Error fetching classes: $e");
    }
  }

}
