import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Components/Form/password_field.dart';
import 'package:passman/Components/Form/text_field.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Pages/login_page.dart';
import 'package:passman/Pages/main_page.dart';
import 'package:passman/Utils/auth_service.dart';
import 'package:passman/app_theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? result =
      await _authService.signUp(email: _email, password: _password);
      if (result == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign Up Successful')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PMAppBar(title: 'Sign Up'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/pass-man.svg',
                  colorFilter: const ColorFilter.mode(
                      AppTheme.primaryColor, BlendMode.srcIn),
                  width: 100,
                  height: 100,
                ),
                PMTextField(
                  labelText: 'Email',
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  onSaved: (val) => _email = val!,
                ),
                PMPasswordField(
                  labelText: 'Password',
                  validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                  onSaved: (val) => _password = val!,
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const LoginPage())
                    );
                  },
                  child: const Text('Already have an account? Log In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
