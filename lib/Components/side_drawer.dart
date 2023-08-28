import 'package:flutter/material.dart';
import 'package:passman/Utils/auth_service.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Pages/login_logs.dart';
import 'package:passman/Pages/login_page.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Model/User.dart';
import 'dart:convert';

class SidebarDrawer extends StatefulWidget {
  @override
  _SidebarDrawerState createState() => _SidebarDrawerState();
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  final AuthService _authService = AuthService();
  late User? _user = null;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      setState(() {
        _user = User.fromJson(userDataMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_user?.fullName() ?? ''),
            accountEmail: Text(_user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person),
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => BottomBar())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login Logs'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const LoginLogs())
              );
            },
          ),

          // Logout item at the bottom
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
