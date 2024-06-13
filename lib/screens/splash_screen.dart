// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 5), () {}); // Tempo de exibição da splash screen
    Get.to(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'images/task_checklist.riv', // Substitua pelo caminho do seu arquivo .riv
        ),
      ),
    );
  }
}
