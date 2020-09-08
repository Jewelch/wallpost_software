import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_management/services/company_selector.dart';

class CompaniesListScreen extends StatefulWidget {
  @override
  _CompaniesListScreenState createState() => _CompaniesListScreenState();
}

class _CompaniesListScreenState extends State<CompaniesListScreen> {
  List<Company> _companies = [];

  @override
  void initState() {
    _getCompanies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Group Dashboard',
        leading: RoundedIconButton(
          iconName: 'assets/icons/menu.svg',
          iconSize: 12,
          onPressed: () => {   Navigator.pushReplacementNamed(context, RouteNames.leftMenu)},
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Text('Companies List Screen'),
              FlatButton(
                color: Colors.red,
                child: Text('Logout'),
                onPressed: () {
                  LogoutHandler().logout(context);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _companies.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${_companies[index].name}'),
                      onTap: () => _selectCompanyAtIndex(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCompanies() async {
    var companies = await CompaniesListProvider().get();
    setState(() {
      _companies.addAll(companies);
    });
  }

  void _selectCompanyAtIndex(int index) {
    var selectedCompany = _companies[index];
    CompanySelector().selectCompanyForCurrentUser(selectedCompany);
    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.dashboard, (route) => false);
  }
}
