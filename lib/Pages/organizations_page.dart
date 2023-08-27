import 'package:flutter/material.dart';
import 'package:passman/Model/Organization.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/side_drawer.dart';
import 'package:passman/Components/bottom_navigation.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Components/generate_password.dart';
import 'package:passman/Utils/helpers.dart';
import 'dart:convert';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({Key? key}) : super(key: key);

  @override
  _OrganizationsPageState createState() => _OrganizationsPageState();
}