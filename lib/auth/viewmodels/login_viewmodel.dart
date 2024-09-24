import 'package:flutter/cupertino.dart';
import 'package:it4788_20241/auth/models/login_data.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final LoginData loginData = LoginData();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void updateEmail(String email) {
    loginData.email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    loginData.password = password;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Call API to login
    }
  }
}