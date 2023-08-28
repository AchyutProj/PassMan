import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'dart:convert';

class CredentialPage extends StatefulWidget {
  final int credentialId;
  final String credentialName;

  const CredentialPage({
    Key? key,
    required this.credentialId,
    required this.credentialName,
  }) : super(key: key);

  @override
  _CredentialPageState createState() => _CredentialPageState();
}

class _CredentialPageState extends State<CredentialPage> {
  int _credentialId = 0;
  Credential? _credential;
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;
  late bool _showPass = false;

  @override
  void initState() {
    super.initState();
    _fetchCredential(widget.credentialId);
  }

  static Future<Credential> getCredential(int credentialId) async {
    final String endpoint = 'credentials/show/$credentialId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      print(response['message']);
    }
    return Credential.fromJson(response['data']);
  }

  Future<void> _fetchCredential(int credentialId) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      Credential credential = await getCredential(credentialId);
      setState(() {
        _credential = credential;
        _isLoading = false;
      });
    }
  }

  Widget _buildDetailItem(String label, String value,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        obscureText: isPassword && _showPass ? true : false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          suffixIcon: isPassword
              ? Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // added line
                  mainAxisSize: MainAxisSize.min, // added line
                  children: <Widget>[
                      IconButton(
                        icon: Icon(!_showPass ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          pmHelper.copyToClipboard(value);
                        },
                      )
                    ])
              : null,
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }

  Widget _buildCredentialDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailItem('Username', _credential!.username),
        _buildDetailItem('Password', _credential!.password, isPassword: true),
        _buildDetailItem('Website', _credential!.url),
        _buildDetailItem('Notes', _credential!.remarks),
      ],
    );
  }

  Widget _buildCredentialDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildCredentialDetails(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PMAppBar(
        title: widget.credentialName ?? 'Credential Details',
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomBar(initialIndex: 1)));
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _credential == null
              ? const Center(
                  child: Text('No credential found'),
                )
              : _buildCredentialDetailsCard(),
    );
  }
}
