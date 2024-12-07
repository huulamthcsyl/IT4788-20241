import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/services/class_material_service.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';
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
  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }

  void logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}