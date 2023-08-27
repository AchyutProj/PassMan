import 'package:flutter/material.dart';
import 'package:passman/Model/Organization.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Components/generate_password.dart';
import 'package:passman/Components/Form/text_field.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Utils/helpers.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchOrganization(widget.organizationId);
  }

  static Future<Organization> getOrganization(int organizationId) async {
    final String endpoint = 'organizations/show/$organizationId';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return Organization();
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
                    BottomBar(initialIndex: 1),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Text('Organization ID: ${widget.organizationId}'),
      ),
    );
  }
}
