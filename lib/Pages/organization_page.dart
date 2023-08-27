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
  // Use widget.organizationId to access the organization ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PMAppBar(
        title: widget.organizationName ?? 'Organization Details',
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
          },
        ),
      ),
      body: Center(
        child: Text('Organization ID: ${widget.organizationId}'),
      ),
    );
  }
}
