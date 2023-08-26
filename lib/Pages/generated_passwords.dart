import 'package:flutter/material.dart';
import 'package:passman/Model/GeneratedPassword.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/side_drawer.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Components/generate_password.dart';
import 'package:passman/Utils/helpers.dart';
import 'dart:convert';

class GeneratedPasswords extends StatefulWidget {
  const GeneratedPasswords({Key? key}) : super(key: key);

  @override
  _GeneratedPasswordsState createState() => _GeneratedPasswordsState();
}

class _GeneratedPasswordsState extends State<GeneratedPasswords> {
  late List<GeneratedPassword> _generatedPasswords = [];
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchGeneratedPasswords();
  }

  static Future<List<GeneratedPassword>> getGeneratedPasswords() async {
    final String endpoint = 'generated-passwords';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return [];
    }
    return response['data']
        .map<GeneratedPassword>((generatedPassword) =>
            GeneratedPassword.fromJson(generatedPassword))
        .toList()
        .reversed
        .toList();
  }

  Future<void> _fetchGeneratedPasswords() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      List<GeneratedPassword> generatedPasswords =
          await getGeneratedPasswords();
      setState(() {
        _generatedPasswords = generatedPasswords;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PMAppBar(
        title: 'Generated Passwords',
      ),
      drawer: SidebarDrawer(),
      body: Column(
        children: [
          GeneratePasswords(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Generated Passwords',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor)),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  onPressed: _fetchGeneratedPasswords,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _generatedPasswords.length == 0
                    ? Center(
                        child: Text('No Generated Passwords'),
                      )
                    : ListView.builder(
                        itemCount: _generatedPasswords.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(_generatedPasswords[index].password),
                              subtitle:
                                  Text(_generatedPasswords[index].createdAt),
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}
