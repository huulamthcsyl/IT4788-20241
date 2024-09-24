import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:it4788_20241/auth/widgets/input_field.dart';
import 'package:it4788_20241/auth/widgets/password_field.dart';
import 'package:it4788_20241/auth/widgets/submit_button.dart';
import 'package:it4788_20241/main.dart';
import 'package:it4788_20241/utils/validate_email.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final SignUpViewModel viewModel = context.watch<SignUpViewModel>();
    return Scaffold(
        backgroundColor: Colors.red,
        body: Form(
            key: viewModel.formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đăng ký tài khoản QLDT",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 20),
                  InputField(
                    hint: "Họ và tên",
                    prefixIcon: const Icon(Icons.person),
                    update: viewModel.updateEmail,
                    validate: validateEmail,
                    controller: viewModel.nameController,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hint: "Email",
                    prefixIcon: const Icon(Icons.email),
                    update: viewModel.updateEmail,
                    validate: validateEmail,
                    controller: viewModel.emailController,
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    hint: "Mật khẩu",
                    update: viewModel.updatePassword,
                    validate: validateEmail,
                    controller: viewModel.passwordController,
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    hint: "Nhập lại mật khẩu",
                    update: viewModel.updatePassword,
                    validate: validateEmail,
                    controller: viewModel.confirmPasswordController,
                  ),
                  const SizedBox(height: 20),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.red,
                    ),
                    child: DropdownButtonFormField(
                      style: const TextStyle(color: Colors.white),
                      hint: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Chọn vai trò',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      items: const [
                        DropdownMenuItem(
                          value: 'Sinh viên',
                          child: Text('Sinh viên',
                              style: TextStyle(color: Colors.white)),
                        ),
                        DropdownMenuItem(
                          value: 'Giảng viên',
                          child: Text('Giảng viên',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                      onChanged: (value) =>
                          viewModel.updateRole(value.toString()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SubmitButton(
                      title: 'ĐĂNG KÝ',
                      action: () => viewModel.signUp(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Đã có tài khoản?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
