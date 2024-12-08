import 'package:flutter/material.dart';
import 'package:it4788_20241/home/views/home_view.dart';
import 'package:it4788_20241/layout/viewmodels/layout_viewmodel.dart';
import 'package:it4788_20241/notification/views/notification_view.dart';
import 'package:it4788_20241/profile/views/profile_view.dart';
import 'package:provider/provider.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    final LayoutViewModel viewModel = context.watch<LayoutViewModel>();
    return Scaffold(
      body: <Widget>[
        const HomeView(),
        const ProfilePage(),
        const HomeView(),
        const NotificationView()
      ][viewModel.currentPageIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: viewModel.updateCurrentPageIndex,
        selectedIndex: viewModel.currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            label: "Trang chủ",
          ),
          const NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(
              Icons.person,
              color: Colors.red,
            ),
            label: "Cá nhân",
          ),
          const NavigationDestination(
            icon: Icon(Icons.message),
            selectedIcon: Icon(
              Icons.message,
              color: Colors.red,
            ),
            label: "Tin nhắn",
          ),
          NavigationDestination(
            icon: Badge.count(
              count: viewModel.unreadNotificationCount,
              child: const Icon(
                Icons.notifications,
              ),
            ),
            selectedIcon: Badge.count(
              textColor: Colors.red,
              backgroundColor: Colors.white,
              count: viewModel.unreadNotificationCount,
              child: const Icon(
                Icons.notifications,
                color: Colors.red,
              ),
            ),
            label: "Thông báo",
          ),
        ]
      ),
    );
  }
}
