import 'package:flutter/material.dart';

class PMPasswordField extends StatefulWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const PMPasswordField({
    Key? key,
    required this.labelText,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  _PMPasswordFieldState createState() => _PMPasswordFieldState();
}

class _PMPasswordFieldState extends State<PMPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
      obscureText: obscureText,
    );
  }
}
