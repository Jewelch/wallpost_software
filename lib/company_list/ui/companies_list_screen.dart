import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/company_details_provider.dart';
import 'package:wallpost/company_list/ui/company_list_card_with_revenue.dart';
import 'package:wallpost/company_list/ui/company_list_card_without_revenue.dart';
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
  Loader loader;

  @override
  void initState() {
    super.initState();
    _getCompanies();
    _searchTextController.addListener(() => _performSearch());
    loader = Loader(context);
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
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
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryContrastColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(children: [
              _createSearchView(),
              Expanded(child: _createListWidget()),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _createListWidget() {
    if (_companies.isNotEmpty)
      return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (context, index) {
            return _getCompanyCard(index);
          },
        ),
      );
    else if (_companiesListProvider.isLoading == false) {
      return _buildErrorAndRetryView();
    } else {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _createSearchView() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryContrastColor,
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
        autocorrect: false,
        enableSuggestions: false,
        controller: _searchTextController,
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                'Failed to load companies\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyles.failureMessageTextStyle,
              ),
              onPressed: () {
                setState(() {});
                _getCompanies();
              },
            ),
          ],
        ),
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

  void _getCompanies() async {
    try {
      var companies = await _companiesListProvider.get();
      setState(() {
        _companies.addAll(companies);
        _filterList.addAll(companies);
      });
    } on WPException catch (error) {
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Load Companies',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
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

  void _selectCompanyAtIndex(int index) async {
    var selectedCompany = _filterList[index];
    await loader.show('');
    try {
      var _ = await CompanyDetailsProvider().getCompanyDetails(selectedCompany.id);
      await loader.hide();
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.dashboard, (route) => false);
    } on WPException catch (e) {
      await loader.hide();
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Load Company Details',
        message: e.userReadableMessage,
        buttonTitle: 'Okay',
      );
    }
  }
}
