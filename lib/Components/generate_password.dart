import 'package:flutter/material.dart';
import 'package:passman/Model/GeneratedPassword.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratePasswords extends StatefulWidget {
  const GeneratePasswords({Key? key}) : super(key: key);

  @override
  _GeneratePasswordsState createState() => _GeneratePasswordsState();
}

class _GeneratePasswordsState extends State<GeneratePasswords> {
  PMHelper pmHelper = PMHelper();
  final passwordController = TextEditingController();

  void _generateNewPassword() async {
    Map<String, dynamic> newPasswordConf = {
      'length': 12,
      'lowercase': true,
      'uppercase': true,
      'numbers': true,
      'symbols': true,
    };

    String newPassword = pmHelper.generatePassword(newPasswordConf);
    passwordController.text = newPassword;
  }

  @override
  void initState() {
    super.initState();
    _generateNewPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _generateNewPassword,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
