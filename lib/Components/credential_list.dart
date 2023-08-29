import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Pages/credential_page.dart';
import 'package:passman/Utils/helpers.dart';

class CredentialList extends StatefulWidget {

  final List<Credential> credentials;
  final int? organizationId;
  final String? organizationName;

  const CredentialList({
    Key? key,
    required this.credentials,
    this.organizationId,
    this.organizationName,
  }) : super(key: key);

  @override
  _CredentialListState createState() => _CredentialListState();
}

class _CredentialListState extends State<CredentialList> {
  List<Credential> get credentials => widget.credentials;
  PMHelper pmHelper = PMHelper();

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
    return ListView.builder(
      itemCount: credentials.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: ListTile(
            title: Text(credentials[index].name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryColor.withOpacity(0.8))),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  'Link',
                  credentials[index].url,
                ),
                _buildDetailItem(
                  'Login',
                  credentials[index].username,
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                bool copied = pmHelper.copyToClipboard(credentials[index].password);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(copied ? 'Password copied to clipboard' : 'Failed to copy password')),
                );
              },
            ),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  CredentialPage(
                    credentialId: credentials[index].id,
                    credentialName: credentials[index].name,
                    organizationId: widget.organizationId,
                    organizationName: widget.organizationName,
                  )
              ));
            }
          ),
        );
      },
    );
  }
}
