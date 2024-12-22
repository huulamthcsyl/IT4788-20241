import 'package:it4788_20241/class_another_function/views/class_function_view.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_assignment/views/assignment_list_view.dart';
import 'package:it4788_20241/class_attendance/views/class_attendance_view.dart';
import 'package:it4788_20241/leave/views/leave_request_list_view.dart';
import 'package:it4788_20241/leave/views/leave_request_view.dart';
import '../../auth/models/user_data.dart';
import '../../classCtrl/models/class_data.dart';
import '../../class_material/views/class_material_view.dart';
import '../../utils/get_data_user.dart';
class ClassFunctionViewModel extends ChangeNotifier
{
  ClassFunctionViewModel()
  {
    initUserData();
  }
  ClassData classData = ClassData(classId: '', classCode: '', className: '', maxStudents: 0, classType: '', status: '', studentAccounts: []);
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
  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }
  void onClickTabBar(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AssignmentListView(classData: classData)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassMaterialPage(classData: classData,)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassFunctionPage(classData: classData)),
        );
        break;
    }
  }
  void onSelectAction(String role, int selectedIndex, BuildContext context){
    switch (role)
    {
      case "LECTURER":
        switch (selectedIndex)
        {
          case 0:
            Navigator.push((context), MaterialPageRoute(builder: (context) => ClassAttendanceView(classData: classData)));
            break;
          case 1:
            Navigator.push((context), MaterialPageRoute(builder: (context) => LeaveRequestListPage(classId: classData.classId,)));
        }
        break;
      case "STUDENT":
        switch (selectedIndex)
        {
          case 0:
            Navigator.push((context), MaterialPageRoute(builder: (context) => LeaveRequestPage(className: classData.className, classId: classData.classId,)));
            break;
        }
        break;
    }
  }
}