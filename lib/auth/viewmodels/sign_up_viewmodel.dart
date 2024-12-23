import 'package:flutter/cupertino.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';
import 'package:toastification/toastification.dart';

import '../services/auth_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final SignUpData signUpData = SignUpData();
  final _authService = AuthService();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String errorMessage = '';

  void init(){
    firstNameController.text = "";
    secondNameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
  }

  void updateEmail(String email) {
    signUpData.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    signUpData.password = password;
    notifyListeners();
  }

  void updateSecondName(String ho) {
    signUpData.ho = ho;
    notifyListeners();
  }

  void updateFirstName(String ten) {
    signUpData.ten = ten;
    notifyListeners();
  }

  void updateRole(String role) {
    signUpData.role = role;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    errorMessage = '';
    if (formKey.currentState!.validate()) {
      try {
        await _authService.signUp(signUpData);
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.simple,
          title: Text('Đăng ký thành công'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(12.0),
          showIcon: false,
        );
        Navigator.pop(context);
      } on GlobalException catch (e) {
        errorMessage = e.toString();
      }
    }
    notifyListeners();
  }
}