import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';

import '../../layout/viewmodels/layout_viewmodel.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final LoginData loginData = LoginData(
    email: '',
    password: '',
    deviceId: '',
  );
  final _authService = AuthService();
  final _firebaseService = FirebaseService();
  final _layoutViewModel = LayoutViewModel();
  String errorMessage = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void init() {
    emailController.text = "";
    passwordController.text = "";
  }

  void updateEmail(String email) {
    loginData.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    loginData.password = password;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    errorMessage = '';
    if (formKey.currentState!.validate()) {
      try {
        final fcmToken = await _firebaseService.getFirebaseToken();
        loginData.fcmToken = fcmToken;
        await _authService.login(loginData);
        _layoutViewModel.updateCurrentPageIndex(0);
        Navigator.pushNamed(context, '/layout');
      } on GlobalException catch (e) {
        errorMessage = e.toString();
      }
    }
    notifyListeners();
  }
}