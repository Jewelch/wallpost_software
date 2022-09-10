import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:notifiable/notifiable.dart';
import 'package:wallpost/_common_widgets/banners/bottom_banner.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/company_dashboard/company_dashboard_screen.dart';
import 'package:wallpost/dashboard/group_dashboard/ui/presenters/group_dashboard_presenter.dart';
import 'package:wallpost/dashboard/group_dashboard/ui/view_contracts/group_dashboard_view.dart';

import '../../../../_common_widgets/search_bar/search_bar.dart';
import '../../../../_wp_core/company_management/entities/company.dart';
import '../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../../../../attendance/attendance_punch_in_out/ui/views/attendance_widget.dart';
import '../../../../left_menu/left_menu_screen.dart';
import '../../../aggregated_approvals_list/ui/views/aggregated_approvals_list_screen.dart';
import 'financial_summary_card.dart';
import 'group_dashboard_app_bar.dart';
import 'group_dashboard_list_card_with_revenue.dart';
import 'group_dashboard_list_card_without_revenue.dart';
import 'group_dashboard_loader.dart';

class GroupDashboardScreen extends StatefulWidget {
  @override
  _GroupDashboardScreenState createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen>
    with WidgetsBindingObserver
    implements GroupDashboardView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  late GroupDashboardPresenter presenter;

  var _errorMessage = "";
  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: LOADER_VIEW);
  var _filtersBarVisibilityNotifier = ItemNotifier<bool>(defaultValue: false);
  var _companyListNotifier = Notifier();
  var _attendanceWidgetNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  void initState() {
    presenter = GroupDashboardPresenter(this);
    presenter.loadDashboardData();
    presenter.loadAttendanceDetails();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    presenter.stopListeningToNotifications();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) presenter.syncDataInBackground();
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
              return GroupDashboardLoader();
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
    return Column(
      children: [
        SizedBox(height: 10),
        _appBarWithoutSearchButton(),
        SizedBox(height: 10),
        Expanded(
          child: Container(
            child: TextButton(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyles.titleTextStyle,
              ),
              onPressed: () => presenter.refresh(),
            ),
          ),
        ),
      ],
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
        _attendanceView(),
        if (presenter.getApprovalCount() > 0)
          BottomBanner(
            approvalCount: presenter.getApprovalCount(),
            onTap: () => presenter.showAggregatedApprovals(),
          ),
      ],
    );
  }

  //MARK: Functions to build the top bar

  Widget _topBar() {
    return ItemNotifiable<bool>(
      notifier: _filtersBarVisibilityNotifier,
      builder: (context, showFiltersBar) => showFiltersBar ? _filtersBar() : _appBarWithSearchButton(),
    );
  }

  Widget _appBarWithSearchButton() {
    return GroupDashboardAppBar(
      profileImageUrl: presenter.getProfileImageUrl(),
      onLeftMenuButtonPressed: () => LeftMenuScreen.show(context),
      onSearchButtonPressed: () => _filtersBarVisibilityNotifier.notify(true),
    );
  }

  Widget _appBarWithoutSearchButton() {
    return GroupDashboardAppBar(
      profileImageUrl: presenter.getProfileImageUrl(),
      onLeftMenuButtonPressed: () => LeftMenuScreen.show(context),
      onSearchButtonPressed: () {},
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
              child: Text("Cancel", style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.red)),
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
        separatorBuilder: (BuildContext context, int index) => index == 0 ? Container() : Divider(),
      ),
    );
  }

  Widget _getCompanyCard(Company companyListItem) {
    if (companyListItem.financialSummary == null) {
      return GroupDashboardListCardWithoutRevenue(
        company: companyListItem,
        onPressed: () => presenter.selectCompany(companyListItem),
      );
    } else {
      return GroupDashboardListCardWithRevenue(
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

  //MARK: Function to build the attendance view

  Widget _attendanceView() {
    return ItemNotifiable<bool>(
      notifier: _attendanceWidgetNotifier,
      builder: (context, shouldShowAttendanceWidget) {
        if (shouldShowAttendanceWidget) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 30),
            child: AttendanceWidget(),
          );
        } else {
          return Container();
        }
      },
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
  void goToCompanyDashboardScreen(Company company) {
    ScreenPresenter.present(
      CompanyDashboardScreen(company.id, company.name),
      context,
      slideDirection: SlideDirection.fromBottom,
    ).then((_) => presenter.syncDataInBackground());
  }

  @override
  void goToApprovalsListScreen() {
    ScreenPresenter.present(
      AggregatedApprovalsListScreen(),
      context,
    ).then((_) => presenter.syncDataInBackground());
  }

  @override
  void showAttendanceWidget() {
    _attendanceWidgetNotifier.notify(true);
  }
}
