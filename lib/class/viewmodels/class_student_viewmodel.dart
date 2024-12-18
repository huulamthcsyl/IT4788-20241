import 'package:flutter/material.dart';
import '../../classCtrl/models/class_data.dart';
import '../../class_material/views/class_material_view.dart';
import '../models/class_model.dart';
import '../repositories/class_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import '../../auth/models/user_data.dart';

class ClassStudentViewModel with ChangeNotifier {
  final ClassRepository _classRepository = ClassRepository();

  List<ClassInfo> registeredClasses = [];
  List<ClassInfo> newClasses = [];
  List<String> newClassIds = [];
  ClassData classData = ClassData(classId: '', classCode: '', className: '', maxStudents: 0, classType: '', status: '', studentAccounts: []);
  void ChangePage(ClassInfo classInfo, BuildContext context){
    this.classData.classId = classInfo.class_id;
    this.classData.className = classInfo.class_name;
    this.classData.classCode = classInfo.attached_code;
    this.classData.classType = classInfo.class_type;
    notifyListeners();
    Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialPage(classData: this.classData,)));
  }
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
