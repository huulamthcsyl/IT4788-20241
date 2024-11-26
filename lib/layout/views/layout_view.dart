import 'package:flutter/material.dart';
import 'package:it4788_20241/home/views/home_view.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const HomeView()
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (value) => {
          setState(() {
            currentPageIndex = value;
          })
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            selectedIcon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            label: "Trang chủ",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(
              Icons.person,
              color: Colors.red,
            ),
            label: "Cá nhân",
          ),
          NavigationDestination(
            icon: Icon(Icons.message),
            selectedIcon: Icon(
              Icons.message,
              color: Colors.red,
            ),
            label: "Tin nhắn",
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            selectedIcon: Icon(
              Icons.notifications,
              color: Colors.red,
            ),
            label: "Thông báo",
          ),
        ]
      ),
    );
  }
}
