import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_list/presenters/company_list_presenter.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';
import 'package:wallpost/company_list/views/company_list_app_bar.dart';
import 'package:wallpost/company_list/views/company_list_card_with_revenue.dart';
import 'package:wallpost/company_list/views/company_list_card_without_revenue.dart';
import 'package:wallpost/company_list/views/company_list_loader.dart';
import 'package:wallpost/company_list/views/financial_summary_card.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';

import '../../_common_widgets/search_bar/search_bar.dart';

class CompanyListScreen extends StatefulWidget {
  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> implements CompaniesListView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  late CompanyListPresenter presenter;

  var _errorMessage = "";
  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: 0);
  var _filtersBarVisibilityNotifier = ItemNotifier<bool>(defaultValue: false);
  var _financialSummaryNotifier = ItemNotifier<FinancialSummary?>(defaultValue: null);
  var _companyListNotifier = ItemNotifier<List<CompanyListItem>>(defaultValue: []);

  @override
  void initState() {
    presenter = CompanyListPresenter(this);
    presenter.loadCompanies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ItemNotifiable<int>(
            notifier: _viewSelectorNotifier,
            builder: (context, viewType) {
              if (viewType == LOADER_VIEW) {
                return CompanyListLoader();
              } else if (viewType == ERROR_VIEW) {
                return _errorAndRetryView();
              } else if (viewType == DATA_VIEW) {
                return _dataView();
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyles.titleTextStyle,
              ),
              onPressed: () => presenter.refresh(),
            ),
          ],
        ),
      ),
    );
  }

  //MARK: Functions to build the data view

  Widget _dataView() {
    return Column(
      children: [
        SizedBox(height: 10),
        _topBar(),
        SizedBox(height: 10),
        _financialSummaryView(),
        Expanded(child: _companyList()),
        _approvalCountBanner(),
      ],
    );
  }

  //MARK: Functions to build the top bar

  Widget _topBar() {
    return ItemNotifiable<bool>(
      notifier: _filtersBarVisibilityNotifier,
      builder: (context, showFiltersBar) => showFiltersBar ? _filtersBar() : _appBar(),
    );
  }

  Widget _appBar() {
    return CompanyListAppBar(
      profileImageUrl: presenter.getProfileImageUrl(),
      onSearchButtonPressed: () => _filtersBarVisibilityNotifier.notify(true),
    );
  }

  Widget _filtersBar() {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: SearchBar(
                hint: 'Search',
                onSearchTextChanged: (searchText) => presenter.performSearch(searchText),
              ),
            ),
            GestureDetector(
              onTap: () => _filtersBarVisibilityNotifier.notify(false),
              child: Text("Cancel", style: TextStyle(color: AppColors.cautionColor, fontSize: 18)),
            ),
            SizedBox(width: 12),
          ],
        ),
        if (presenter.shouldShowCompanyGroupsFilter()) SizedBox(height: 8),
        if (presenter.shouldShowCompanyGroupsFilter())
          Container(
            height: 40,
            child: MultiSelectFilterChips(
              titles: presenter.getCompanyGroups().map((e) => e.name).toList(),
              selectedIndices: [],
              onItemSelected: (index) => presenter.selectGroupAtIndex(index),
              onItemDeselected: (index) => presenter.clearGroupSelection(),
            ),
          ),
      ],
    );
  }

  //MARK: Functions to build the financial summary view

  Widget _financialSummaryView() {
    return ItemNotifiable<FinancialSummary?>(
      notifier: _financialSummaryNotifier,
      builder: (context, summary) => summary != null ? FinancialSummaryCard(summary) : Container(),
    );
  }

  //MARK: Functions to build the company list

  Widget _companyList() {
    return ItemNotifiable<List<CompanyListItem>>(
      notifier: _companyListNotifier,
      builder: (context, companyList) {
        if (companyList.isEmpty)
          return _noCompaniesView();
        else
          return _companyListView(companyList);
      },
    );
  }

  Widget _companyListView(List<CompanyListItem> companies) {
    return RefreshIndicator(
      onRefresh: () => presenter.refresh(),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          return _getCompanyCard(companies[index]);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }

  Widget _getCompanyCard(CompanyListItem companyListItem) {
    if (companyListItem.financialSummary == null) {
      return CompanyListCardWithoutRev(
        company: companyListItem,
        onPressed: () => presenter.selectCompany(companyListItem),
      );
    } else {
      return CompanyListCardWithRevenue(
        company: companyListItem,
        onPressed: () => presenter.selectCompany(companyListItem),
      );
    }
  }

  Widget _noCompaniesView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "There are no companies for the given search criteria.",
              textAlign: TextAlign.center,
              style: TextStyles.titleTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  //MARK: Functions to build the approval count banner

  Widget _approvalCountBanner() {
    if (presenter.getApprovalCount() == 0) return SizedBox();

    return Container(
      height: 50,
      color: AppColors.bannerBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SvgPicture.asset(
              'assets/icons/exclamation_icon.svg',
              color: Colors.white,
              width: 14,
              height: 18,
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text("Approvals", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          new Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "${presenter.getApprovalCount()}",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void onDidLoadData() {
    _viewSelectorNotifier.notify(DATA_VIEW);
  }

  @override
  void updateFinancialSummary(FinancialSummary? groupSummary) {
    _financialSummaryNotifier.notify(groupSummary);
  }

  @override
  void updateCompanyList(List<CompanyListItem> companies) {
    _companyListNotifier.notify(companies);
  }

  @override
  void goToCompanyDetailScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(DashboardScreen(), context);
  }
}
