import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/network_adapter/exceptions/api_exception.dart';
import 'package:wallpost/company_management/entities/company_list_item.dart';
import 'package:wallpost/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_management/ui/company_list_card_with_revenue.dart';
import 'package:wallpost/company_management/ui/company_list_card_without_revenue.dart';
import 'package:wallpost/dashboard/ui/left_menu_screen.dart';

class CompaniesListScreen extends StatefulWidget {
  @override
  _CompaniesListScreenState createState() => _CompaniesListScreenState();
}

class _CompaniesListScreenState extends State<CompaniesListScreen> {
  CompaniesListProvider _companiesListProvider = CompaniesListProvider();
  List<CompanyListItem> _companies = [];
  List<CompanyListItem> _filterList = [];
  var _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCompanies();
    _searchTextController.addListener(() => _performSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Group Dashboard',
        leading: RoundedIconButton(
          iconName: 'assets/icons/menu.svg',
          iconSize: 12,
          onPressed: () => ScreenPresenter.present(LeftMenuScreen(), context, slideDirection: SlideDirection.fromLeft),
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
            child: _createListWidget(),
          ),
        ),
      ),
    );
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
          hintText: 'Search By Company Name',
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

  Widget _createListWidget() {
    if (_companies.isNotEmpty)
      return Column(
        children: [
          _createSearchView(),
          Expanded(
            child: ListView.builder(
              itemCount: _filterList.length,
              itemBuilder: (context, index) {
                return _getCompanyCard(index);
              },
            ),
          ),
        ],
      );
    else if (_companiesListProvider.isLoading == false) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load companies',
                style: (TextStyle(color: AppColors.labelColor, fontSize: 16)),
              ),
              FlatButton(
                child: Text('Tap Here To Retry'),
                onPressed: () {
                  setState(() {});
                  _getCompanies();
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _getCompanyCard(int index) {
    if (_filterList[index].shouldShowRevenue)
      return CompanyListCardWithRevenue(
        company: _filterList[index],
        onPressed: () => {
          _selectCompanyAtIndex(index),
        },
      );
    else
      return CompanyListCardWithOutRevenue(
        company: _filterList[index],
        onPressed: () => {
          _selectCompanyAtIndex(index),
        },
      );
  }

  void _selectCompanyAtIndex(int index) {
    var selectedCompany = _filterList[index];

    //TODO:  Get company and employee details
//    CompanySelector().selectCompanyForCurrentUser(selectedCompany);
//    Navigator.pushNamedAndRemoveUntil(context, RouteNames.dashboard, (route) => false);
  }

  void _getCompanies() async {
    try {
      var companies = await _companiesListProvider.get();
      setState(() {
        _companies.addAll(companies);
        _filterList.addAll(companies);
      });
    } on APIException catch (error) {
      Alert.showSimpleAlert(context,
          title: 'Failed To Load Companies', message: error.userReadableMessage, buttonTitle: 'Okay');
      setState(() {});
    }
  }

  void _performSearch() {
    _filterList = new List<CompanyListItem>();
    for (int i = 0; i < _companies.length; i++) {
      var item = _companies[i];
      if (item.name.toLowerCase().contains(_searchTextController.text.toLowerCase())) {
        _filterList.add(item);
      }
    }
    setState(() {});
  }
}
