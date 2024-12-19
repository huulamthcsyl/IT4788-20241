import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/viewmodels/login_viewmodel.dart';
import 'package:it4788_20241/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:it4788_20241/auth/views/sign_up_view.dart';
import 'package:it4788_20241/class/viewmodels/class_student_viewmodel.dart';
import 'package:it4788_20241/class/views/class_student_view.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrlForm_viewmodel.dart';
import 'package:it4788_20241/classCtrl/views/classCtrl_view.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:it4788_20241/chat/viewmodels/chat_overview_viewmodel.dart';
import 'package:it4788_20241/chat/viewmodels/conversation_viewmodel.dart';
import 'package:it4788_20241/chat/views/chat_overview_view.dart';
import 'package:it4788_20241/class_another_function/viewmodels/class_function_viewmodel.dart';
import 'package:it4788_20241/class_attendance/viewmodels/class_attendance_viewmodel.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:it4788_20241/classCtrl/service/api_service.dart';
import 'package:it4788_20241/home/viewmodels/home_viewmodel.dart';
import 'package:it4788_20241/layout/viewmodels/layout_viewmodel.dart';
import 'package:it4788_20241/layout/views/layout_view.dart';
import 'package:it4788_20241/notification/viewmodels/notification_detail_viewmodel.dart';
import 'package:it4788_20241/notification/viewmodels/notification_tile_viewmodel.dart';
import 'package:it4788_20241/notification/viewmodels/notification_viewmodel.dart';
import 'package:it4788_20241/notification/views/notification_view.dart';
import 'package:it4788_20241/leave/viewmodels/leave_request_list_viewmodel.dart';
import 'package:it4788_20241/leave/viewmodels/leave_request_viewmodel.dart';
import 'package:it4788_20241/profile/viewmodels/profile_viewmodel.dart';
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
import 'class_attendance/views/class_attendance_view.dart';
import 'home/views/home_view.dart';
import 'package:it4788_20241/class/views/class_student_view.dart';
import 'package:it4788_20241/class/viewmodels/class_student_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ClassRegisterViewModel()),
        ChangeNotifierProvider(create: (context) => ClassListViewModel()),
        ChangeNotifierProvider(create: (context) => ClassMaterialViewModel()),
        ChangeNotifierProvider(create: (context) => ClassAttendanceViewModel()),
        ChangeNotifierProvider(create: (context) => ClassCtrlViewModel()),
        ChangeNotifierProvider(create: (context) => ClassCtrlFormViewModel()),
        ChangeNotifierProvider(create: (context) => LayoutViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationDetailViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationTileViewModel()),
        ChangeNotifierProvider(create: (context) => LeaveRequestViewModel()),
        ChangeNotifierProvider(create: (context) => LeaveRequestListViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
        ChangeNotifierProvider(create: (context) => SearchViewModel()),
        ChangeNotifierProvider(create: (context) => ClassFunctionViewModel()),
        ChangeNotifierProvider(create: (context) => ClassStudentViewModel()),
        ChangeNotifierProvider(create: (context) => ChatOverviewViewModel()),
        ChangeNotifierProvider(create: (context) => ConversationViewModel()),
      ],
      child: MaterialApp(
        title: 'QLDT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF8F8FF),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const SplashView(),
          '/login': (context) => const LoginView(),
          '/layout': (context) => const AppLayout(),
          '/sign-up': (context) => const SignUpView(),
          '/home': (context) => const HomeView(),
          '/class-register': (context) => RegisterClassPage(),
          '/class-list': (context) => ClassListPage(),
          '/class-attendance': (context) => ClassAttendancePage(),
          '/class-control': (context) => ClassCtrlPage(),
          '/search': (context) => SearchPage(),
          '/notification': (context) => const NotificationView(),
          '/students-class' : (context) => ClassStudentPage()
        },
        initialRoute: '/',
      ),
    );
  }
}
