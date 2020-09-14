import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_management/services/company_selector.dart';
import 'package:wallpost/company_management/ui/company_list_card_without_revenue.dart';

class CompaniesListScreen extends StatefulWidget {
  @override
  _CompaniesListScreenState createState() => _CompaniesListScreenState();
}

class _CompaniesListScreenState extends State<CompaniesListScreen> {
  List<Company> _companies = [];
  List<Company> _filterList = [];

  var _searchTextController = TextEditingController();
  bool _showClearButton = false;
  String _query = "";

  @override
  void initState() {
    _getCompanies();

    _searchTextController.addListener(() {
      setState(() {
        _query = _searchTextController.text;

        _performSearch();
      });
    });
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
          onPressed: () =>
              {Navigator.of(context).pushNamed(RouteNames.leftMenu)},
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: [
                _createSearchView(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filterList.length,
                    itemBuilder: (context, index) {
                      return CompanyListCardWithOutRevenue(
                          company: _filterList[index],
                          onPressed: () => {
                                _selectCompanyAtIndex(index),
                              });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getCompanies() async {
    var companies = await CompaniesListProvider().get();
    setState(() {
      _companies.addAll(companies);
      _filterList.addAll(companies);
    });
  }

  Widget _createSearchView() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: AppColors.groupDashboardSearchViewColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search..',
          suffixIcon: _getClearButton(),
          border: InputBorder.none,
        ),
        controller: _searchTextController,
      ),
    );
  }

  Widget _getClearButton() {
    if (_searchTextController.text.isEmpty) {
      return IconButton(
        onPressed: () => _searchTextController.clear(),
        icon: Icon(Icons.search),
      );
    }

    return IconButton(
      onPressed: () => _searchTextController.clear(),
      icon: Icon(Icons.clear),
    );
  }

  void _performSearch() {
    _filterList = new List<Company>();
    for (int i = 0; i < _companies.length; i++) {
      var item = _companies[i];

      if (item.name.toLowerCase().contains(_query.toLowerCase())) {
        setState(() {
          _filterList.add(item);
        });
      }
    }
  }

  void _selectCompanyAtIndex(int index) {
    var selectedCompany = _companies[index];
    CompanySelector().selectCompanyForCurrentUser(selectedCompany);
    Navigator.pushNamedAndRemoveUntil(
        context, RouteNames.dashboard, (route) => false);
  }
}
