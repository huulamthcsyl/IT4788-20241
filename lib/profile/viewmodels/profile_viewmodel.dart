import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/services/class_material_service.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';
import '../../auth/services/auth_service.dart';
class ProfileViewModel extends ChangeNotifier
{

  final AuthService _authService = AuthService();

  ProfileViewModel() {
    initUserData();
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
  UserData searchUserData = UserData(
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

  void logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
  void getInformationFromUser(int id) async {
    searchUserData = await _authService.getUserInfo(id.toString());
    notifyListeners();
  }
  String textError = '';
  void changePassword(BuildContext context, String oldPassword, String newPassword) async {
    if (oldPassword.isEmpty){
      textError = "Chưa điền mật khẩu cũ";
      notifyListeners();
      return;
    }
    if (newPassword.isEmpty){
      textError = "Chưa điền mật khẩu mới";
      notifyListeners();
      return;
    }
    if (oldPassword == newPassword){
      textError = "Mật khẩu mới không thể giống mật khẩu cũ";
      notifyListeners();
      return;
    }
    final token = (await getUserData()).token ?? "";
    await _authService.changePassword(token: token, old_password: oldPassword, new_password: newPassword);
    Navigator.of(context).pop();
  }
}