import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFD35400); // Orange color
  static const Color secondaryHeaderColor = Color(0xFF2980B9); // Blue color
  // Add more color constants as needed

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryHeaderColor,
    );
  }
}
