import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Components/Form/elevated_button.dart';
import 'package:passman/Components/Form/password_field.dart';
import 'package:passman/Components/Form/text_field.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Pages/main_page.dart';
import 'package:passman/Pages/sign_up_page.dart';
import 'package:passman/Utils/auth_service.dart';
import 'package:passman/app_theme.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String? result =
          await _authService.signIn(email: _email, password: _password);
      if (result == "") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login Successful')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PMAppBar(title: 'Login'),
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
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
                const SizedBox(height: 5),
                PMElevatedButton(
                  onPressed: _login,
                  label: 'Login',
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const SignUpPage())
                    );
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
