import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Model/Statistics.dart';
import 'package:passman/Utils/api_service.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late bool _isLoading = false;
  Statistics? _statistics;

  @override
  void initState() {
    super.initState();
    _fetchStatistics();
  }

  static Future<Statistics> getStatistics() async {
    final String endpoint = 'statistics';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      Statistics.fromJson({});
    }
    return Statistics.fromJson(response['data']);
  }

  Future<void> _fetchStatistics() async {
    setState(() {
      _isLoading = true;
    });
    Statistics statistics = await getStatistics();
    setState(() {
      _statistics = statistics;
      _isLoading = false;
    });
  }

  Widget StatBox({required String title, required int value}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _isLoading ? [
                CircularProgressIndicator(),
              ] : [
                StatBox(title: 'Credentials', value: _statistics?.credentials ?? 0),
                const SizedBox(height: 20),
                StatBox(title: 'Organizations', value: _statistics?.organizations ?? 0),
                const SizedBox(height: 20),
                StatBox(title: 'Generated Passwords', value: _statistics?.generatedPasswords ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
