import 'package:it4788_20241/class_another_function/views/class_function_view.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../../auth/models/user_data.dart';
import '../../class_material/views/class_material_view.dart';
import '../../utils/get_data_user.dart';
class ClassFunctionViewModel extends ChangeNotifier
{
  ClassFunctionViewModel()
  {
    initUserData();
  }
  String classCode = "";
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
          MaterialPageRoute(builder: (context) => ClassSurveyPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassMaterialPage(classCode: classCode)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClassFunctionPage(classCode: classCode)),
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
            // Chuyển tới page xem danh sách điểm danh
            break;
          case 1:
            // Chuyển tới page xem danh sách đơn xin nghỉ
        }
        break;
      case "STUDENT":
        switch (selectedIndex)
        {
          case 0:
            // Chuyển tới page gửi đơn xin vắng mặt
            break;
        }
        break;
    }
  }
}