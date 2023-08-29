import 'package:flutter/material.dart';
import 'package:passman/Model/Organization.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Components/Form/text_field.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Components/organization_passwords.dart';
import 'package:passman/Pages/credential_add_edit_page.dart';
import 'package:passman/Utils/helpers.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class OrganizationPage extends StatefulWidget {
  final int organizationId;
  final String organizationName;

  const OrganizationPage({
    Key? key,
    required this.organizationId,
    required this.organizationName,
  }) : super(key: key);

  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  int _organizationId = 0;
  Organization? _organization;
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;

  late List<Credential> _credentials = [];

  @override
  void initState() {
    super.initState();
    _fetchOrganization(widget.organizationId);
    _fetchCredentials(widget.organizationId);
  }

  static Future<Organization> getOrganization(int organizationId) async {
    final String endpoint = 'organizations/show/$organizationId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      print(response['message']);
    }
    return Organization.fromJson(response['data']);
  }

  Future<void> _fetchOrganization(int organizationId) async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      Organization organization = await getOrganization(organizationId);
      setState(() {
        _organization = organization;
        _isLoading = false;
      });
    }
  }

  static Future<List<Credential>> getCredentials(int organizationId) async {
    final String endpoint = 'organizations/credentials/$organizationId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return [];
    }
    return response['data']
        .map<Credential>((credential) => Credential.fromJson(credential))
        .toList()
        .reversed
        .toList();
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    return Scaffold(
        appBar: PMAppBar(
          title: widget.organizationName ?? 'Organization Details',
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      BottomBar(initialIndex: 2),
                ),
              );
            },
          ),
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
                    'Organization Details',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            Container(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Column(
                          children: [
                            _buildDetailItem(
                                'Name', _organization?.name ?? 'N/A'),
                            _buildDetailItem(
                                'Email', _organization?.email ?? 'N/A'),
                            _buildDetailItem(
                                'Website', _organization?.website ?? 'N/A'),
                            _buildDetailItem('Phone Number',
                                _organization?.phoneNumber ?? 'N/A'),
                            _buildDetailItem(
                                'Remarks', _organization?.remarks ?? 'N/A'),
                            _buildDetailItem(
                              'Created At',
                              pmHelper.formatDateTime(
                                _organization?.createdAt ??
                                    DateFormat("yyyy-MM-dd hh:mm:ss")
                                        .format(DateTime.now()),
                              ),
                            ),
                          ],
                        ),
                      )),
            Flexible(
              child: Container(
                child: OrganizationsPasswords(
                  organizationId: widget.organizationId,
                  organizationName: widget.organizationName,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CredentialAddEditPage(
                  credentialId: 0,
                  credentialName: 'Add Credential',
                  organizationId: widget.organizationId ?? 0,
                  organizationName:
                      widget.organizationName ?? 'Organization Details',
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
