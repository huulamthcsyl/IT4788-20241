import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/viewmodels/login_viewmodel.dart';
import 'package:it4788_20241/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:it4788_20241/auth/views/sign_up_view.dart';
import 'package:provider/provider.dart';
import './auth/views/login_view.dart';
import 'package:it4788_20241/class/views/class_register_view.dart';
import 'package:it4788_20241/class/viewmodels/class_register_viewmodel.dart';
import 'package:it4788_20241/class/views/class_list_view.dart';
import 'package:it4788_20241/class/viewmodels/class_list_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LoginViewModel()),
          ChangeNotifierProvider(create: (context) => SignUpViewModel()),
          ChangeNotifierProvider(create: (_) => ClassRegisterViewModel()),
          ChangeNotifierProvider(create: (context) => ClassListViewModel()),
        ],
        child: MaterialApp(
            title: 'QLDT',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routes: {
              '/login': (context) => const LoginView(),
              '/sign-up': (context) => const SignUpView(),
              '/class-register': (context) => RegisterClassPage(),
              '/class-list': (context) => ClassListPage(),
            },
            //home: const LoginView()
            home: RegisterClassPage()
        )
    );
  }
}
