import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passman/Model/GeneratedPassword.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratePasswords extends StatefulWidget {
  final VoidCallback fetchGeneratedPasswords;

  const GeneratePasswords({Key? key, required this.fetchGeneratedPasswords})
      : super(key: key);

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

  Future<void> _copyToClipboard() async {
    Clipboard.setData(ClipboardData(text: passwordController.text));

    final String endpoint = 'generated-passwords/store';

    final Map<String, dynamic> passwordData = {
      'password': passwordController.text,
    };

    final response = await ApiService.post(
      endpoint,
      passwordData,
    );

    if (response.containsKey('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      return;
    } else {
      widget.fetchGeneratedPasswords();
      _generateNewPassword();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password copied to clipboard')),
      );
    }
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
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _generateNewPassword,
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: _copyToClipboard,
                    ),
                  ],
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
