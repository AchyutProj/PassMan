import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Pages/credential_add_edit_page.dart';
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

  Future<void> _deleteCredential(int credentialId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this credential?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _performDelete(credentialId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performDelete(int credentialId) async {
    final String endpoint = 'credentials/delete/$credentialId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      print(response['message']);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBar(initialIndex: 1),
        ),
      );
    }
  }

  Widget _buildDetailItem(String label, String value,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: true,
        obscureText: isPassword && !_showPass ? true : false,
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
                        icon: Icon(!_showPass ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _showPass = !_showPass;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          bool copied = pmHelper.copyToClipboard(value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(copied ? 'Password copied to clipboard' : 'Failed to copy password')),
                          );
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CredentialAddEditPage(
                    credentialId: widget.credentialId,
                    credentialName: _credential!.name,
                  ),
                ),
              );
            },
            child: Icon(Icons.edit),
            backgroundColor: AppTheme.primaryColor,
            heroTag: null, // Added this line to prevent hero animation conflict
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _deleteCredential(widget.credentialId),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red, // You can change this to a color of your choice
            heroTag: null, // Added this line to prevent hero animation conflict
          ),
        ],
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
