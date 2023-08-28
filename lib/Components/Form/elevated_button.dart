import 'package:flutter/material.dart';
import 'package:passman/app_theme.dart';

class PMElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  const PMElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = AppTheme.primaryColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      child: Text(label),
    );
  }
}
