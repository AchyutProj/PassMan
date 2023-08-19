import 'package:flutter/material.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Pages/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Password Manager',
      theme: AppTheme.themeData,
      home: SplashScreen(),
    );
  }
}