import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/viewmodels/login_viewmodel.dart';
import 'package:it4788_20241/auth/widgets/input_field.dart';
import 'package:it4788_20241/auth/widgets/password_field.dart';
import 'package:it4788_20241/auth/widgets/submit_button.dart';
import 'package:it4788_20241/utils/validate_email.dart';
import 'package:it4788_20241/utils/validate_password.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = context.watch<LoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.red,
      body: Form(
          key: viewModel.formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Đăng nhập với QLDT",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(height: 20),
                InputField(
                  hint: 'Email hoặc mã số SV/CB',
                  prefixIcon: const Icon(Icons.person),
                  update: viewModel.updateEmail,
                  validate: validateEmail,
                  controller: viewModel.emailController,
                ),
                const SizedBox(height: 20),
                PasswordField(
                  hint: 'Mật khẩu',
                  update: viewModel.updatePassword,
                  validate: validatePassword,
                  controller: viewModel.passwordController,
                ),
                const SizedBox(height: 20),
                SubmitButton(
                  title: 'Đăng nhập',
                  action: () => viewModel.login(context),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Quên mật khẩu?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Chưa có tài khoản?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign-up');
                      },
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}


