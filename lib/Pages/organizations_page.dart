import 'package:flutter/material.dart';
import 'package:passman/Model/Organization.dart';
import 'package:passman/Utils/api_service.dart';
import 'package:passman/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:passman/Components/app_bar.dart';
import 'package:passman/Components/generate_password.dart';
import 'package:passman/Components/Form/text_field.dart';
import 'package:passman/Utils/helpers.dart';
import 'dart:convert';

class OrganizationsPage extends StatefulWidget {
  const OrganizationsPage({Key? key}) : super(key: key);

  @override
  _OrganizationsPageState createState() => _OrganizationsPageState();
}

class _OrganizationsPageState extends State<OrganizationsPage> {
  late List<Organization> _organizations = [];
  PMHelper pmHelper = PMHelper();
  late bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  static Future<List<Organization>> getOrganizations() async {
    final String endpoint = 'organizations';
    final Map<String, dynamic> response = await ApiService.post(endpoint, null);
    if (response.containsKey('error')) {
      return [];
    }
    return response['data']
        .map<Organization>(
            (organization) => Organization.fromJson(organization))
        .toList()
        .reversed
        .toList();
  }

  Future<void> _fetchOrganizations() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      Map<String, dynamic> userDataMap = json.decode(userDataString);
      List<Organization> organizations = await getOrganizations();
      setState(() {
        _organizations = organizations;
        _isLoading = false;
      });
    }
  }

  Future<void> _addOrganizationDialog(BuildContext context) {
    const String endpoint = 'organizations/store';
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    late String _name;
    late String _remarks;

    Future<void> _addOrganization() async {
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('user_data');

      if (userDataString != null) {
        Map<String, dynamic> userDataMap = json.decode(userDataString);
        Map<String, dynamic> data = {
          'name': _name,
          'remarks': _remarks,
        };
        final Map<String, dynamic> response =
        await ApiService.post(endpoint, data);
        if (response.containsKey('error')) {
          return;
        }
        _fetchOrganizations();
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text('Add Organization'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PMTextField(
                  labelText: 'Organization Name',
                  validator: (val) =>
                  val!.isEmpty ? 'Enter organization name' : null,
                  onSaved: (val) => _name = val!,
                ),
                PMTextField(
                  labelText: 'Remarks',
                  validator: (val) =>
                  val!.isEmpty ? 'Enter remarks' : null,
                  onSaved: (val) => _remarks = val!,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addOrganization();
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrganizationDialog(context),
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
                Text('Organizations',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor)),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  onPressed: _fetchOrganizations,
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : _organizations.isEmpty
                ? Center(
              child: Text(
                  'No organizations stored',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor.withOpacity(0.6)
                  )
              ),
            )
                : ListView.builder(
              itemCount: _organizations.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(
                      vertical: 4, horizontal: 16),
                  child: ListTile(
                    title: Text(
                        _organizations[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor
                        )
                    ),
                    subtitle: Text(_organizations[index].remarks),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
