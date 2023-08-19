import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Components/Form/PMPasswordField.dart';
import 'package:passman/Components/Form/PMTextField.dart';
import 'package:passman/Components/PMAppBar.dart';
import 'package:passman/Pages/MainPage.dart';
import 'package:passman/Utils/AuthService.dart';
import 'package:passman/app_theme.dart';

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
      if (result == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
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
                // TextFormField(
                //   decoration: const InputDecoration(labelText: 'Password'),
                //   obscureText: true,
                //   validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                //   onSaved: (val) => _password = val!,
                // ),
                PMPasswordField(
                  labelText: 'Password',
                  validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                  onSaved: (val) => _password = val!,
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    // Implement your functionality here
                  },
                  child: const Text('Forgot Password?'),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    // Implement your functionality here
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
