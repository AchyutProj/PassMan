import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:passman/Components/credential_list.dart';
import 'dart:convert';

class OrganizationsPasswords extends StatefulWidget {
  final int organizationId;

  const OrganizationsPasswords({
    Key? key,
    required this.organizationId,
  }) : super(key: key);

  @override
  _OrganizationsPasswordsState createState() => _OrganizationsPasswordsState();
}

class _OrganizationsPasswordsState extends State<OrganizationsPasswords> {
  late List<Credential> _credentials = [];
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCredentials(widget.organizationId);
  }

  static Future<List<Credential>> getCredentials(int organizationId) async {
    final String endpoint = 'organizations/credentials/$organizationId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return [];
    }
    return List<Credential>.from(
        response['data'].map((credential) => Credential.fromJson(credential)));
  }

  Future<void> _fetchCredentials(int organizationId) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      List<Credential> credentials = await getCredentials(organizationId);
      setState(() {
        _credentials = credentials;
        _isLoading = false;
      });
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Organization Credentials',
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
                onPressed: () => _fetchCredentials(widget.organizationId),
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
    );
  }
}
