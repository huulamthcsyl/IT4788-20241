import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/auth/viewmodels/login_viewmodel.dart';
import 'package:it4788_20241/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:it4788_20241/class_attendance/viewmodels/class_attendance_viewmodel.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:it4788_20241/class/viewmodels/class_register_viewmodel.dart';
import 'package:it4788_20241/class/viewmodels/class_list_viewmodel.dart';
import 'package:it4788_20241/class_assignment/viewmodels/assignment_list_viewmodel.dart';
import 'package:it4788_20241/auth/views/sign_up_view.dart';
import 'package:it4788_20241/auth/views/login_view.dart';
import 'package:it4788_20241/class/views/class_register_view.dart';
import 'package:it4788_20241/class/views/class_list_view.dart';
import 'package:it4788_20241/class_material/views/class_material_view.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:it4788_20241/class_attendance/views/class_attendance_view.dart';
import 'package:it4788_20241/class_assignment/views/assignment_list_view.dart';

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
          ChangeNotifierProvider(create: (context) => ClassRegisterViewModel()),
          ChangeNotifierProvider(create: (context) => ClassListViewModel()),
          ChangeNotifierProvider(create: (context) => ClassMaterialViewModel()),
          ChangeNotifierProvider(create: (context) => ClassAttendanceViewModel()),
          ChangeNotifierProvider(create: (context) => AssignmentListViewModel()),
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
              '/class-material': (context) => ClassMaterialPage(),
              '/class-material-upload': (context) => ClassMaterialUploadFilePage(),
              '/class-attendance': (context) => ClassAttendancePage(),
              '/class-assignment': (context) => const AssignmentListView(),
            },
            //home: const LoginView()
            // home: ClassAttendancePage()
            home: const AssignmentListView()
        )
    );
  }
}
