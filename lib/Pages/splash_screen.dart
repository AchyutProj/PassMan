import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Pages/sign_up_page.dart';
import 'package:passman/app_theme.dart';

import 'main_page.dart'; // Update with your app's import

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpPage()), // Navigate to the main screen
      );
    });
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Set the background color
      body: Center(
        child: SvgPicture.asset(
          'assets/images/pass-man.svg',
          width: 200, // Adjust width as needed
          height: 200, // Adjust height as needed
        ),
      ),
    );
  }
}