import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Pages/login_page.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Utils/auth_service.dart';
import 'package:passman/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService(); // Initialize your AuthService
    final bool isLoggedIn = _authService.currentUser != null;

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          // builder: (context) => isLoggedIn ? MainPage() : const LoginPage()
          builder: (context) => BottomBar()
        ),
      );
    });

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/pass-man.svg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
