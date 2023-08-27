import 'package:flutter/material.dart';
import 'package:passman/Pages/main_page.dart';
import 'package:passman/Pages/generated_passwords.dart';
import 'package:passman/app_theme.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    GeneratedPasswords(),
    Container(
      child: Center(
        child: Text('Settings'),
      ),
    ),
  ];

  void _onTabTapped(int index) {

    print("Index: " +index.toString());
    print("currentIndex: " +_currentIndex.toString());

    if(_currentIndex != index) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );

      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      backgroundColor: AppTheme.primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Organization',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.password),
          label: 'Generate Password',
        ),
      ],
    );
  }
}
