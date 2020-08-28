import 'package:flutter/material.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';
import 'package:wallpost/company_management/services/companies_list_provider.dart';

class CompaniesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Companies List Screen'),
              FlatButton(
                color: Colors.red,
                child: Text('Get Companies'),
                onPressed: () {
                  CompaniesListProvider().getNext();
                },
              ),
              FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () {
                  LogoutHandler().logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
