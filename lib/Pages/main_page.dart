import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:passman/Components/app_bar.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PMAppBar(
        title: 'Password Manager',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/pass-man.svg', // Path to the SVG logo image
              width: 100, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Passman',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your functionality here
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
