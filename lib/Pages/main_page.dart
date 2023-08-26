import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Components/Form/elevated_button.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Pages/login_page.dart';
import 'package:passman/Utils/auth_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/side_drawer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final AuthService _authService = AuthService();
  late SharedPreferences prefs;

  String? userEmail;
  String? token;

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    final user = _authService.currentUser;
    if (user != null) {
      final email = await _authService.getUserEmail(user.uid);
      setState(() {
        userEmail = email;
      });
    }
  }

  Future<void> _initializePrefs() async {
    prefs = await SharedPreferences.getInstance(); // Initialize prefs here
    token = prefs.getString('_token'); // Set the token
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PMAppBar(
        title: 'Password Manager',
      ),
      drawer: SidebarDrawer(),
      body: Center(
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
            const SizedBox(height: 20),
            const Text(
              'Welcome to Passman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (userEmail != null) ...[
              const SizedBox(height: 10),
              Text(
                'Logged in as: $userEmail',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            Text(
              'Token: $token',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            PMElevatedButton(
              label: 'Logout',
              onPressed: () async {
                await _authService.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
