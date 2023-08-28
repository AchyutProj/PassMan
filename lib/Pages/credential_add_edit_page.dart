import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Components/Form/text_field.dart';
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
    setState(() {
      _credentialId = widget.credentialId;
      _appBarTitle = widget.credentialName;
    });
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
      final String endpoint = 'credentials/store';
      final Map<String, dynamic> response =
          await ApiService.post(endpoint, data);
      if (response.containsKey('error')) {
        print(response['message']);
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BottomBar(initialIndex: 1)));
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBar(initialIndex: 1),
              ),
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PMTextField(
                labelText: 'Name',
                value: _Name,
                validator: (val) =>
                    val!.isEmpty ? 'Enter your credential name' : null,
                onSaved: (val) => _Name = val!,
              ),
              PMTextField(
                labelText: 'Url',
                value: _Url,
                validator: (val) =>
                    val!.isEmpty ? 'Enter your credential url' : null,
                onSaved: (val) => _Url = val!,
              ),
              PMTextField(
                labelText: 'Login',
                value: _Username,
                validator: (val) => val!.isEmpty ? 'Enter the login' : null,
                onSaved: (val) => _Username = val!,
              ),
              PMTextField(
                labelText: 'Password',
                value: _Password,
                validator: (val) => val!.isEmpty ? 'Enter the password' : null,
                onSaved: (val) => _Password = val!,
              ),
              PMTextField(
                labelText: 'Remarks',
                value: _Remarks,
                validator: null,
                onSaved: (val) => _Remarks = val!,
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  final Map<String, dynamic> data = {
                    'name': _Name,
                    'url': _Url,
                    'username': _Username,
                    'password': _Password,
                    'remarks': _Remarks,
                  };
                  final String endpoint = 'credentials/store';
                  final Map<String, dynamic> response =
                      await ApiService.post(endpoint, data);
                  if (response.containsKey('error')) {
                    print(response['message']);
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomBar(initialIndex: 0)));
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
