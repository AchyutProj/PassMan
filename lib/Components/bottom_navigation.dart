import 'package:flutter/material.dart';
import 'package:passman/Components/side_drawer.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/app_theme.dart';

import 'package:passman/Pages/main_page.dart';
import 'package:passman/Pages/vault_page.dart';
import 'package:passman/Pages/generated_passwords.dart';
import 'package:passman/Pages/organizations_page.dart';

class BottomBar extends StatefulWidget {
  final int initialIndex;

  BottomBar({this.initialIndex = 0});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    VaultPage(),
    OrganizationsPage(),
    GeneratedPasswords()
  ];

  final List<String> _titles = [
    'PassMan',
    'Vault',
    'Organizations',
    'Generated Passwords'
  ];

  void _onTabTapped(int index) {
    setState(() {
      if (index >= 0 && index < _pages.length) {
        _currentIndex = index;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      appBar: PMAppBar(
        title: _titles[_currentIndex],
      ),
      drawer: SidebarDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: AppTheme.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.vpn_key),
              label: 'Vault',
              backgroundColor: AppTheme.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Organization',
              backgroundColor: AppTheme.primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.password),
              label: 'Generate Password',
              backgroundColor: AppTheme.primaryColor),
        ],
      ),
    );
  }
}
