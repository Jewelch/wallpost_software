import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/aggregated_approvals_list/ui/views/aggregated_approvals_list_screen.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_list/presenters/company_list_presenter.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';
import 'package:wallpost/company_list/views/company_list_app_bar.dart';
import 'package:wallpost/company_list/views/company_list_card_with_revenue.dart';
import 'package:wallpost/company_list/views/company_list_card_without_revenue.dart';
import 'package:wallpost/company_list/views/company_list_loader.dart';
import 'package:wallpost/company_list/views/financial_summary_card.dart';

import '../../_common_widgets/search_bar/search_bar.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../left_menu/left_menu_screen.dart';

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
  var _companyListNotifier = Notifier();

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
        body: ItemNotifiable<int>(
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
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
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
      onLeftMenuButtonPressed: () => LeftMenuScreen.show(context),
      onSearchButtonPressed: () => _filtersBarVisibilityNotifier.notify(true),
    );
  }

  Widget _filtersBar() {
    return Column(
      children: [
        SizedBox(height: 36),
        Row(
          children: <Widget>[
            Expanded(
              child: SearchBar(
                hint: 'Search',
                onSearchTextChanged: (searchText) => presenter.performSearch(searchText),
              ),
            ),
            GestureDetector(
              onTap: () {
                presenter.clearFiltersAndUpdateViews();
                _filtersBarVisibilityNotifier.notify(false);
              },
              child: Text("Cancel", style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.cautionColor)),
            ),
            SizedBox(width: 12),
          ],
        ),
        if (presenter.shouldShowCompanyGroupsFilter()) SizedBox(height: 12),
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

  //MARK: Functions to build the company list

  Widget _companyList() {
    return Notifiable(
      notifier: _companyListNotifier,
      builder: (context) {
        if (presenter.getNumberOfRows() == 0)
          return _noCompaniesView();
        else
          return _companyListView();
      },
    );
  }

  Widget _companyListView() {
    return RefreshIndicator(
      onRefresh: () => presenter.refresh(),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: presenter.getNumberOfRows(),
        itemBuilder: (context, index) {
          if (presenter.getItemAtIndex(index) is FinancialSummary)
            return FinancialSummaryCard(presenter, presenter.getItemAtIndex(index));
          else
            return _getCompanyCard(presenter.getItemAtIndex(index));
        },
        separatorBuilder: (BuildContext context, int index) =>
            index == 0 ? Container() : Divider(color: AppColors.dividerColor),
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
        presenter: presenter,
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

    return GestureDetector(
      onTap: () => presenter.showAggregatedApprovals(),
      child: Container(
        height: Platform.isAndroid ? 50 : 80,
        padding: EdgeInsets.only(bottom: Platform.isAndroid ? 0 : 30, left: 6, right: 6),
        decoration: BoxDecoration(
          color: AppColors.bannerBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.bannerBackgroundColor.withOpacity(0.9),
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            SvgPicture.asset('assets/icons/exclamation_icon.svg', color: Colors.white, width: 16, height: 16),
            SizedBox(width: 10),
            Text("Approvals", style: TextStyles.titleTextStyle.copyWith(color: Colors.white)),
            new Spacer(),
            Text("${presenter.getApprovalCount()}", style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(width: 10)
          ],
        ),
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
  void updateCompanyList() {
    _companyListNotifier.notify();
  }

  @override
  void goToCompanyDetailScreen(CompanyListItem companyListItem) {
    ScreenPresenter.present(DashboardScreen(companyListItem.id, companyListItem.name), context);
  }

  @override
  void goToApprovalsListScreen() {
    ScreenPresenter.present(AggregatedApprovalsListScreen(), context);
  }
}
