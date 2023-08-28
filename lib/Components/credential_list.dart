import 'package:flutter/material.dart';
import 'package:passman/Model/Credential.dart';
import 'package:passman/app_theme.dart';
import 'package:passman/Pages/credential_page.dart';

class CredentialList extends StatefulWidget {
  const CredentialList({Key? key, required this.credentials}) : super(key: key);

  final List<Credential> credentials;

  @override
  _CredentialListState createState() => _CredentialListState();
}

class _CredentialListState extends State<CredentialList> {
  List<Credential> get credentials => widget.credentials;

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
              onPressed: () {},
            ),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  CredentialPage(
                    credentialId: credentials[index].id,
                    credentialName: credentials[index].name
                  )
              ));
            }
          ),
        );
      },
    );
  }
}
