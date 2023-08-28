import 'package:flutter/material.dart';
import 'package:passman/Model/LoginLog.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Components/side_drawer.dart';
import 'package:passman/Utils/helpers.dart';
import 'dart:convert';

class LoginLogs extends StatefulWidget {
  const LoginLogs({Key? key}) : super(key: key);

  @override
  _LoginLogsState createState() => _LoginLogsState();
}

class _LoginLogsState extends State<LoginLogs> {
  late List<LoginLog> _loginLogs = [];
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLoginLogs();
  }

  static Future<List<LoginLog>> getLoginLogs() async {
    final String endpoint = 'logs/login';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return [];
    }
    return response['data']
        .map<LoginLog>((loginLog) => LoginLog.fromJson(loginLog))
        .toList()
        .reversed
        .toList();
  }

  Future<void> _fetchLoginLogs() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      List<LoginLog> loginLogs = await getLoginLogs();
      setState(() {
        _loginLogs = loginLogs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PMAppBar(
        title: 'Login Logs',
      ),
      drawer: SidebarDrawer(),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Login Logs',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor)),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  onPressed: _fetchLoginLogs,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _loginLogs.length > 0
                    ? ListView.builder(
                        itemCount: _loginLogs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                'IP Address: ${_loginLogs[index].ipAddress}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                      'Date: ${pmHelper.formatDateTime(_loginLogs[index].createdAt)}'),
                                  SizedBox(height: 4),
                                  Text('Using: ${_loginLogs[index].userAgent}'),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                            'No login logs found',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor.withOpacity(0.6))),
                      ),
          ),
        ],
      ),
    );
  }
}
