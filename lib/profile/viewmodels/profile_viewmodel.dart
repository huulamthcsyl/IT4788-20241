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
<<<<<<< Updated upstream

  final AuthService _authService = AuthService();

=======
  final _authService = AuthService();
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream

  void logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
=======
  void getInformationFromUser(int id) async {
    searchUserData = await _authService.getUserInfo(id);
    notifyListeners();
>>>>>>> Stashed changes
  }
}