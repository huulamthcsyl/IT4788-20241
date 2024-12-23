import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/home/viewmodels/home_viewmodel.dart';
import 'package:it4788_20241/home/widgets/profile.dart';
import 'package:provider/provider.dart';

import '../../classCtrl/viewmodels/classCtrl_viewmodel.dart';
import '../../classCtrl/views/classCtrlForm_view.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';
import '../widgets/home_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    setState(() {
      homeViewModel.initUserData();
    });
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'HUST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
        ),
        body: buildColumnBasedOnRole(homeViewModel.userData));
  }

  Widget buildColumnBasedOnRole(UserData userData) {
    if (userData.role == "LECTURER") {
      return Column(
        children: [
          const SizedBox(height: 20),
          Profile(userData: userData),
          const SizedBox(height: 20),
          Center( // Bọc Wrap trong Center widget
            child: Wrap(
              spacing: 20, // Khoảng cách ngang giữa các button
              runSpacing: 20, // Khoảng cách dọc giữa các dòng
              alignment: WrapAlignment.center, // Căn giữa các button trong Wrap
              children: [
                HomeButton(
                  title: 'Quản lý lớp học', icon: const ImageIcon(AssetImage('assets/img/class_management_icon.png'), size: 50, color: Colors.red,),
                  onPressed: () {Navigator.pushNamed(context, '/class-control');}),
                 HomeButton(
                  title: 'Tạo lớp học', icon: const ImageIcon(AssetImage('assets/img/class_create_icon.png'), size: 50, color: Colors.red),
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassCtrlFormPage(
                        onSave: (newClass) {
                          context.read<ClassCtrlViewModel>().addClass(newClass);
                        },
                      ),
                    ),
                  );}),
                HomeButton(
                    title: 'Danh sách lớp mở', icon: const ImageIcon(AssetImage('assets/img/class_open_list_icon.png'), size: 50, color: Colors.red,),
                    onPressed: () {Navigator.pushNamed(context, '/class-list');}),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 20),
          Profile(userData: userData),
          const SizedBox(height: 20),
          Center( // Bọc Wrap trong Center widget
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                HomeButton(title: 'Đăng ký lớp học', icon: const ImageIcon(AssetImage('assets/img/class_registration_icon.png'), size: 50, color: Colors.red),
                  onPressed: () {Navigator.pushNamed(context, '/class-register');}),
                HomeButton(title: 'Lớp học trong kỳ', icon: const ImageIcon(AssetImage('assets/img/class_schedule_icon.png'), size: 50, color: Colors.red),
                  onPressed: () {Navigator.pushNamed(context, '/students-class');}),
                HomeButton(
                    title: 'Danh sách lớp mở', icon: const ImageIcon(AssetImage('assets/img/class_open_list_icon.png'), size: 50, color: Colors.red,),
                    onPressed: () {Navigator.pushNamed(context, '/class-list');}),
              ],
            ),
          ),
        ],
      );
    }
  }
}