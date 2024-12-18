import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../repositories/class_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';
import '../../auth/models/user_data.dart';

class ClassRegisterViewModel with ChangeNotifier {
  final ClassRepository _classRepository = ClassRepository();
  final TextEditingController _classCodeController = TextEditingController();
  TextEditingController get classCodeController => _classCodeController;
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

  ClassRegisterViewModel() {
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

  Future<void> addNewClass(String classId) async {
    try {
      if (newClassIds.contains(classId) || registeredClasses.any((classItem) => classItem.class_id == classId)) {
        print("Class already registered or pending registration.");
        return;
      } else {
        final classInfo = await _classRepository.getBasicClassInfo(userData.token, classId, userData.id);
        if (classInfo != null) {
          newClasses.add(classInfo);
          newClassIds.add(classId);
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error fetching basic class info: $e");
    }
  }

  Future<void> submitRegistration() async {
    try {
      if (newClassIds.isNotEmpty) {
        final result = await _classRepository.registerClasses(userData.token, newClassIds);
        if (result) {
          registeredClasses.addAll(newClasses);
          newClasses.clear();
          newClassIds.clear();
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error submitting registration: $e");
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
