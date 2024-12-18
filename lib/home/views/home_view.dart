import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/home/viewmodels/home_viewmodel.dart';
import 'package:it4788_20241/home/widgets/profile.dart';
import 'package:provider/provider.dart';

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
      body: buildColumnBasedOnRole(homeViewModel.userData)
    );

  }
  Widget buildColumnBasedOnRole(UserData userData)
  {
    if (userData.role == "LECTURER")
    {
      return Column(
        children: [
          const SizedBox(height: 20),
          Profile(userData: userData),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeButton(
                title: 'Quản lý lớp học',
                icon: const ImageIcon(
                  AssetImage('assets/img/class_management_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/class-control');
                },
              ),
              const SizedBox(width: 20),
              HomeButton(
                title: 'Lịch dạy',
                icon: const ImageIcon(
                  AssetImage('assets/img/teaching_schedule_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/teaching-schedule');
                },
              ),
              const SizedBox(width: 20),
              HomeButton(
                title: 'Tạo lớp học',
                icon: const ImageIcon(
                  AssetImage('assets/img/teaching_schedule_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/teaching-schedule');
                },
              ),
              const SizedBox(width: 20),
              HomeButton(
                title: 'Lịch dạy',
                icon: const ImageIcon(
                  AssetImage('assets/img/teaching_schedule_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/teaching-schedule');
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 20),
          Profile(userData: userData),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeButton(
                title: 'Đăng ký lớp học',
                icon: const ImageIcon(
                  AssetImage('assets/img/class_registration_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/class-list');
                },
              ),
              const SizedBox(width: 20),
              HomeButton(
                title: 'Lịch học',
                icon: const ImageIcon(
                  AssetImage('assets/img/class_schedule_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeButton(
                title: 'Lớp học trong kỳ',
                icon: const ImageIcon(
                  AssetImage('assets/img/absence_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/');
                },
              ),
              const SizedBox(width: 20),
              HomeButton(
                title: 'Quản lý lớp học',
                icon: const ImageIcon(
                  AssetImage('assets/img/class_management_icon.png'),
                  size: 50,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ],
          )
        ],
      );
    }
  }
}
