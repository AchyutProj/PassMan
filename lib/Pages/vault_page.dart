import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Components/credential_list.dart';
import 'package:passman/Pages/credential_add_edit_page.dart';
import 'dart:convert';

class VaultPage extends StatefulWidget {
  const VaultPage({Key? key}) : super(key: key);

  @override
  _VaultPageState createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  late List<Credential> _credentials = [];
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCredentials();
  }

  static Future<List<Credential>> getCredentials() async {
    final String endpoint = 'credentials';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return [];
    }
    return List<Credential>.from(
        response['data'].map((credential) => Credential.fromJson(credential)));
  }

  Future<void> _fetchCredentials() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      List<Credential> credentials = await getCredentials();
      setState(() {
        _credentials = credentials;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CredentialAddEditPage(
                credentialId: 0,
                credentialName: 'Add Credential',
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credentials',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  onPressed: () => _fetchCredentials(),
                ),
              ],
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _credentials.isEmpty
                  ? const Center(
                      child: Text('No credentials found'),
                    )
                  : Flexible(
                      child: CredentialList(
                        credentials: _credentials,
                      ),
                    ),
        ],
      ),
    );
  }
}
