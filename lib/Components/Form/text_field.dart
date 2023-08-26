import 'package:flutter/material.dart';

class PMTextField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;

  const PMTextField({
    super.key,
    required this.labelText,
    this.validator,
    this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
          obscureText: obscureText,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
