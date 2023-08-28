import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Components/Form/elevated_button.dart';
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
  late String _firstName;
  late String _middleName;
  late String _lastName;
  late String _username;
  late String _email;
  late String _password;

  late bool _disabledButton = false;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      _disabledButton = true;
      _formKey.currentState!.save();
      String? result =
          await _authService.signUp(
              firstName: _firstName,
              middleName: _middleName,
              lastName: _lastName,
              username: _username,
              email: _email,
              password: _password
          );
      if (result == "") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sign Up Successful')));
      } else {
        _disabledButton = false;
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
                  labelText: 'First Name',
                  validator: (val) =>
                      val!.isEmpty ? 'Enter your first name' : null,
                  onSaved: (val) => _firstName = val!,
                ),
                PMTextField(
                  labelText: 'Middle Name',
                  validator: null,
                  onSaved: (val) => _middleName = val!,
                ),
                PMTextField(
                  labelText: 'Last Name',
                  validator: (val) =>
                      val!.isEmpty ? 'Enter your last name' : null,
                  onSaved: (val) => _lastName = val!,
                ),
                PMTextField(
                  labelText: 'Username',
                  validator: (val) =>
                      val!.isEmpty ? 'Enter a username' : null,
                  onSaved: (val) => _username = val!,
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
                PMElevatedButton(
                  onPressed: _disabledButton ? () {} : _signUp,
                  label: _disabledButton ? 'Signing Up...' : 'Sign Up',
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
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
