import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  checkUser() async {
    final AuthService authServices = AuthService();
    const FlutterSecureStorage storage = FlutterSecureStorage();
    try {
      final user = await getUserData();
      final userInfo = await authServices.getUserInfo(user.id);
      final updatedUser = user.copyWith(
        ho: userInfo.ho,
        ten: userInfo.ten,
        name: userInfo.name,
        email: userInfo.email,
        status: userInfo.status,
        role: userInfo.role,
        avatar: userInfo.avatar,
      );
      storage.write(
        key: 'user',
        value: utf8.encode(jsonEncode(updatedUser.toJson())).toString()
      );
      Navigator.pushReplacementNamed(context, '/layout');
    } catch (e) {
      await storage.delete(key: 'user');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.red,
      body: const Center(
          child: const CircularProgressIndicator(
        color: Colors.white,
      )),
    );
  }
}
