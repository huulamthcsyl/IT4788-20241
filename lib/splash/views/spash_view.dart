import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
   checkUser() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final user = await storage.read(key: 'user');
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/class-register');
    } else {
      Navigator.pushReplacementNamed(context, '/class-register');
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
      body: const Center(child: const CircularProgressIndicator(color: Colors.white,)),
    );
  }
}
