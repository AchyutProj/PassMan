import 'package:flutter/material.dart';

class PMTextField extends StatelessWidget {
  final String labelText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool obscureText;
  final String value;
  final IconButton? suffixIcon;

  PMTextField({
    Key? key,
    required this.labelText,
    this.validator,
    this.readOnly = false,
    this.onSaved,
    this.value = '',
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

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
            suffixIcon: suffixIcon,
          ),
          validator: validator,
          onSaved: onSaved,
          obscureText: obscureText,
          initialValue: value,
          readOnly: readOnly,
          onChanged: (value) {
            onSaved!(value);
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
