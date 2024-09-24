import 'package:flutter/cupertino.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final SignUpData signUpData = SignUpData();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void updateEmail(String email) {
    signUpData.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    signUpData.password = password;
    notifyListeners();
  }

  void updateName(String name) {
    signUpData.name = name;
    notifyListeners();
  }

  void updateRole(String role) {
    signUpData.role = role;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Call API to sign up
    }
  }
}