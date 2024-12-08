import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/viewmodels/login_viewmodel.dart';
import 'package:it4788_20241/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:it4788_20241/auth/views/sign_up_view.dart';
import 'package:it4788_20241/classCtrl/views/classCtrl_view.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:it4788_20241/class_another_function/viewmodels/class_function_viewmodel.dart';
import 'package:it4788_20241/class_another_function/views/class_function_view.dart';
import 'package:it4788_20241/class_attendance/viewmodels/class_attendance_viewmodel.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/home/viewmodels/home_viewmodel.dart';
import 'package:it4788_20241/leave/viewmodels/leave_request_list_viewmodel.dart';
import 'package:it4788_20241/leave/viewmodels/leave_request_viewmodel.dart';
import 'package:it4788_20241/leave/views/leave_request_view.dart';
import 'package:it4788_20241/layout/viewmodels/layout_viewmodel.dart';
import 'package:it4788_20241/layout/views/layout_view.dart';
import 'package:it4788_20241/notification/viewmodels/notification_detail_viewmodel.dart';
import 'package:it4788_20241/notification/viewmodels/notification_tile_viewmodel.dart';
import 'package:it4788_20241/notification/viewmodels/notification_viewmodel.dart';
import 'package:it4788_20241/profile/viewmodels/profile_viewmodel.dart';
import 'package:it4788_20241/profile/views/profile_view.dart';
import 'package:it4788_20241/search/viewmodels/search_viewmodel.dart';
import 'package:it4788_20241/search/views/search_view.dart';
import 'package:it4788_20241/splash/views/spash_view.dart';
import 'package:provider/provider.dart';
import './auth/views/login_view.dart';
import 'package:it4788_20241/class/views/class_register_view.dart';
import 'package:it4788_20241/class/viewmodels/class_register_viewmodel.dart';
import 'package:it4788_20241/class/views/class_list_view.dart';
import 'package:it4788_20241/class/viewmodels/class_list_viewmodel.dart';
import 'package:it4788_20241/class_material/views/class_material_view.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:it4788_20241/leave/views/leave_request_list_view.dart';
import 'class_attendance/views/class_attendance_view.dart';
import 'home/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LayoutViewModel()),
          ChangeNotifierProvider(create: (context) => LoginViewModel()),
          ChangeNotifierProvider(create: (context) => SignUpViewModel()),
          ChangeNotifierProvider(create: (context) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => ClassRegisterViewModel()),
          ChangeNotifierProvider(create: (context) => ClassListViewModel()),
          ChangeNotifierProvider(create: (context) => ClassMaterialViewModel()),
          ChangeNotifierProvider(create: (context) => ClassAttendanceViewModel()),
          ChangeNotifierProvider(create: (context) => LeaveRequestViewModel()),
          ChangeNotifierProvider(create: (context) => LeaveRequestListViewModel()),
          ChangeNotifierProvider(create: (context) => NotificationViewModel()),
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
          ChangeNotifierProvider(create: (context) => ClassFunctionViewModel()),
          ChangeNotifierProvider(create: (context) => NotificationDetailViewModel()),
          ChangeNotifierProvider(create: (context) => NotificationTileViewModel()),
          ChangeNotifierProvider(create: (context) => SearchViewModel())
          ChangeNotifierProvider(create: (context) => SearchViewModel()),
          ChangeNotifierProvider(create: (context) => ClassCtrlViewModel()),
        ],
        child: MaterialApp(
            title: 'QLDT',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF8F8FF),
              useMaterial3: true,
            ),
            /*routes: {
              '/': (context) => const SplashView(),
              '/layout': (context) => const AppLayout(),
              '/login': (context) => const LoginView(),
              '/sign-up': (context) => const SignUpView(),
              '/home': (context) => const HomeView(),
              '/class-register': (context) => RegisterClassPage(),
              '/class-list': (context) => ClassListPage(),
              '/class-material': (context) => ClassMaterialPage(),
              '/class-material-upload': (context) => ClassMaterialUploadFilePage(),
              '/class-attendance': (context) => ClassAttendancePage(),
              '/leave-request': (context) => LeaveRequestPage()
            },*/
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(builder: (_) => const SplashView());
                case '/login':
                  return MaterialPageRoute(builder: (_) => const LoginView());
                case '/sign-up':
                  return MaterialPageRoute(builder: (_) => const SignUpView());
                case '/home':
                  return MaterialPageRoute(builder: (_) => const HomeView());
                case '/class-register':
                  return MaterialPageRoute(builder: (_) => RegisterClassPage());
                case '/class-list':
                  return MaterialPageRoute(builder: (_) => ClassListPage());
                case '/class-material':
                  return MaterialPageRoute(builder: (_) => ClassMaterialPage());
                case '/class-material-upload':
                  return MaterialPageRoute(builder: (_) => ClassMaterialUploadFilePage());
                case '/class-attendance':
                  return MaterialPageRoute(builder: (_) => ClassAttendancePage());
                case '/leave-request-list':
                  final args = settings.arguments as Map<String, dynamic>?;
                  final classId = args?['classId'] as String? ?? '';
                  return MaterialPageRoute(builder: (_) => LeaveRequestListPage(classId: classId));
                case '/leave-request':
                  final args = settings.arguments as Map<String, dynamic>?;
                  final classId = args?['classId'] as String? ?? '';
                  return MaterialPageRoute(builder: (_) => LeaveRequestPage(classId: classId),);
                default:
                  return MaterialPageRoute(builder: (_) =>
                  const Scaffold(
                    body: Center(child: Text('Trang không tồn tại')),),);
              }
              '/user/profile': (context) => ProfilePage(),
              '/class-another-functions': (context) => ClassFunctionPage(),
              '/search' : (context) => SearchPage(),
              '/class-control': (context) => ClassCtrlPage()
            },
            initialRoute: "/",
        )
    );
  }
}