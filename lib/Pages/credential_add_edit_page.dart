import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Components/Form/text_field.dart';
import 'package:passman/Pages/credential_page.dart';
import 'dart:convert';

class CredentialAddEditPage extends StatefulWidget {
  final int credentialId;
  final String credentialName;

  const CredentialAddEditPage({
    Key? key,
    required this.credentialId,
    required this.credentialName,
  }) : super(key: key);

  @override
  _CredentialAddEditPageState createState() => _CredentialAddEditPageState();
}

class _CredentialAddEditPageState extends State<CredentialAddEditPage> {
  int _credentialId = 0;
  String _appBarTitle = "Add Credential";
  Credential? _credential;
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;
  late bool _showPass = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _Name = '';
  late String _Url = '';
  late String _Username = '';
  late String _Password = '';
  late String _Remarks = '';

  @override
  void initState() {
    super.initState();

    if (widget.credentialId != 0) {
      _fetchCredential(widget.credentialId);
    }

    setState(() {
      _appBarTitle = widget.credentialName;
    });
  }

  static Future<Credential> getCredential(int credentialId) async {
    final String endpoint = 'credentials/show/$credentialId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return Credential.fromJson({});
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

  void _addEditCred() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Map<String, dynamic> data = {
        'name': _Name,
        'url': _Url,
        'username': _Username,
        'password': _Password,
        'remarks': _Remarks,
      };
      final String storeEndpoint = 'credentials/store';
      final String updateEndpoint = 'credentials/update/${widget.credentialId}';
      final String endpoint = widget.credentialId == 0 ? storeEndpoint : updateEndpoint;
      final Map<String, dynamic> response =
          await ApiService.post(endpoint, data);
      if (response.containsKey('error')) {
        SnackBar snackBar = SnackBar(
          content: Text(response['message']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BottomBar(initialIndex: 1)));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response['message']}')
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PMAppBar(
        title: _appBarTitle ?? 'Credential Details',
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.credentialId != 0
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CredentialPage(
                          credentialId: widget.credentialId,
                          credentialName: widget.credentialName),
                    ),
                  )
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomBar(initialIndex: 1),
                    ),
                  );
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PMTextField(
                      labelText: 'Name',
                      value: _credential != null ? _credential!.name : '',
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your credential name' : null,
                      onSaved: (val) => _Name = val!,
                    ),
                    PMTextField(
                      labelText: 'Url',
                      value: _credential != null ? _credential!.url : '',
                      validator: (val) =>
                          val!.isEmpty ? 'Enter your credential url' : null,
                      onSaved: (val) => _Url = val!,
                    ),
                    PMTextField(
                      labelText: 'Login',
                      value: _credential != null ? _credential!.username : '',
                      validator: (val) =>
                          val!.isEmpty ? 'Enter the login' : null,
                      onSaved: (val) => _Username = val!,
                    ),
                    PMTextField(
                      labelText: 'Password',
                      value: _credential != null ? _credential!.password : '',
                      validator: (val) =>
                          val!.isEmpty ? 'Enter the password' : null,
                      onSaved: (val) => _Password = val!,
                    ),
                    PMTextField(
                      labelText: 'Remarks',
                      value: _credential != null ? _credential!.remarks : '',
                      validator: null,
                      onSaved: (val) => _Remarks = val!,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: () => _addEditCred(),
                      child: Text('Save'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
