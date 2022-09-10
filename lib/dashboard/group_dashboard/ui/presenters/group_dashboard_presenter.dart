import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/company_selector.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/dashboard/group_dashboard/entities/group_dashboard_data.dart';
import 'package:wallpost/notification_center/notification_center.dart';

import '../../../../_wp_core/company_management/entities/company.dart';
import '../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../../../../attendance/attendance_punch_in_out/services/attendance_details_provider.dart';
import '../../../../notification_center/notification_observer.dart';
import '../../entities/company_group.dart';
import '../../services/group_dashboard_data_provider.dart';
import '../models/financial_details.dart';
import '../view_contracts/group_dashboard_view.dart';

class GroupDashboardPresenter {
  final GroupDashboardView _view;
  final CurrentUserProvider _currentUserProvider;
  final GroupDashboardDataProvider _groupDashboardDataProvider;
  final CompanySelector _companySelector;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final NotificationCenter _notificationCenter;

  GroupDashboardData? _groupDashboardData;
  var _searchText = "";
  CompanyGroup? _selectedGroup;

  GroupDashboardPresenter(GroupDashboardView view)
      : this.initWith(
          view,
          CurrentUserProvider(),
          GroupDashboardDataProvider(),
          CompanySelector(),
          AttendanceDetailsProvider(),
          NotificationCenter.getInstance(),
        );

  GroupDashboardPresenter.initWith(
    this._view,
    this._currentUserProvider,
    this._groupDashboardDataProvider,
    this._companySelector,
    this._attendanceDetailsProvider,
    this._notificationCenter,
  ) {
    _startListeningToNotifications();
  }

  //MARK: Functions to start and stop listening to notifications

  void _startListeningToNotifications() {
    _notificationCenter.addExpenseApprovalRequiredObserver(
      NotificationObserver(key: "groupDashboard", callback: (_) => syncDataInBackground()),
    );
    _notificationCenter.addLeaveApprovalRequiredObserver(
      NotificationObserver(key: "groupDashboard", callback: (_) => syncDataInBackground()),
    );
    _notificationCenter.addAttendanceAdjustmentApprovalRequiredObserver(
      NotificationObserver(key: "groupDashboard", callback: (_) => syncDataInBackground()),
    );
  }

  void stopListeningToNotifications() {
    _notificationCenter.removeObserverFromAllChannels(key: "groupDashboard");
  }

  //MARK: Functions to load attendance

  Future<void> loadAttendanceDetails() async {
    try {
      var attendanceDetails = await _attendanceDetailsProvider.getDetails();
      if (attendanceDetails.isAttendanceApplicable) _view.showAttendanceWidget();
    } on WPException {
      //do nothing
    }
  }

  //MARK: Functions to load company list

  Future<void> loadDashboardData() async {
    if (_groupDashboardDataProvider.isLoading) return;

    _clearFilters();
    _view.showLoader();

    try {
      var groupDashboardData = await _groupDashboardDataProvider.get();
      _handleResponse(groupDashboardData);
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void _handleResponse(GroupDashboardData groupDashboardData) {
    _groupDashboardData = groupDashboardData;

    if (_groupDashboardData!.companies.isNotEmpty) {
      _view.onDidLoadData();
      _view.updateCompanyList();
    } else {
      _view.showErrorMessage("There are no companies.\n\nTap here to reload.");
    }
  }

  List<Company> _getFilteredCompanies() {
    var allCompanies = _groupDashboardData!.companies;
    var companyIdsFilteredByGroup = _selectedGroup?.companyIds ?? allCompanies.map((c) => c.id).toList();
    var companiesFilteredByGroup = allCompanies.where((c) => companyIdsFilteredByGroup.contains(c.id)).toList();
    var companiesFilteredBySearchText = companiesFilteredByGroup.where((c) {
      return c.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return companiesFilteredBySearchText;
  }

  FinancialSummary? _getFilteredFinancialSummary() {
    FinancialSummary? summaryToShow;
    if (_selectedGroup != null && _selectedGroup?.financialSummary != null) {
      summaryToShow = _selectedGroup?.financialSummary;
    } else if (_groupDashboardData!.financialSummary != null) {
      summaryToShow = _groupDashboardData!.financialSummary;
    }

    if (_groupDashboardData!.shouldShowFinancialData() && summaryToShow != null) {
      return summaryToShow;
    } else {
      return null;
    }
  }

  //MARK: Functions to sync the dashboard data in the background

  Future<void> syncDataInBackground() async {
    if (_groupDashboardData == null) return;

    try {
      var existingData = _groupDashboardData!;
      var newData = await _groupDashboardDataProvider.get();
      if (_didDataChange(existingData, newData)) {
        _groupDashboardData = newData;
        _handleResponse(newData);
      }
    } on WPException catch (_) {
      //do nothing
    }
  }

  bool _didDataChange(GroupDashboardData existingData, GroupDashboardData newData) {
    return _getTotalApprovalCount(existingData) != _getTotalApprovalCount(newData) ||
        existingData.companies.length != newData.companies.length;
  }

  //MARK: Function to refresh the dashboard data

  refresh() {
    _clearFilters();
    loadDashboardData();
  }

  //MARK: Functions to perform search

  void performSearch(String searchText) {
    _searchText = searchText;
    _view.updateCompanyList();
  }

  //MARK: Functions to select and deselect company group filter

  void selectGroupAtIndex(int index) {
    _selectedGroup = _groupDashboardData!.groups[index];
    _view.updateCompanyList();
  }

  void clearGroupSelection() {
    _selectedGroup = null;
    _view.updateCompanyList();
  }

  //MARK: Functions to clear filters

  void clearFiltersAndUpdateViews() {
    _clearFilters();
    _view.updateCompanyList();
  }

  void _clearFilters() {
    _searchText = "";
    _selectedGroup = null;
  }

  //MARK: Functions to perform selections

  void selectCompany(Company company) async {
    _companySelector.selectCompanyForCurrentUser(company);
    _view.goToCompanyDashboardScreen(company);
  }

  void showAggregatedApprovals() {
    _view.goToApprovalsListScreen();
  }

  //MARK: Functions to get number of rows and items

  int getNumberOfRows() {
    if (_getFilteredCompanies().isEmpty) return 0;

    if (_getFilteredFinancialSummary() != null)
      return _getFilteredCompanies().length + 1;
    else
      return _getFilteredCompanies().length;
  }

  dynamic getItemAtIndex(int index) {
    if (_getFilteredFinancialSummary() != null) {
      if (index == 0)
        return _getFilteredFinancialSummary();
      else
        return _getFilteredCompanies()[index - 1];
    } else {
      return _getFilteredCompanies()[index];
    }
  }

  //MARK: Functions to get financial details

  FinancialDetails getProfitLossDetails(FinancialSummary? summary, {bool isForHeaderCard = false}) {
    if (summary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Profit & Loss",
      value: summary.profitLoss,
      textColor: summary.isInProfit() ? _successColor(isForHeaderCard) : _failureColor(isForHeaderCard),
    );
  }

  FinancialDetails getAvailableFundsDetails(FinancialSummary? summary, {bool isForHeaderCard = false}) {
    if (summary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Available Funds",
      value: summary.availableFunds,
      textColor: summary.areFundsAvailable() ? _successColor(isForHeaderCard) : _failureColor(isForHeaderCard),
    );
  }

  FinancialDetails getOverdueReceivablesDetails(FinancialSummary? summary, {bool isForHeaderCard = false}) {
    if (summary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Receivables Overdue",
      value: summary.receivableOverdue,
      textColor: summary.areReceivablesOverdue() ? _failureColor(isForHeaderCard) : _successColor(isForHeaderCard),
    );
  }

  FinancialDetails getOverduePayablesDetails(FinancialSummary? summary, {bool isForHeaderCard = false}) {
    if (summary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Payables Overdue",
      value: summary.payableOverdue,
      textColor: summary.arePayablesOverdue() ? _failureColor(isForHeaderCard) : _successColor(isForHeaderCard),
    );
  }

  FinancialDetails _emptyFinancialDetails() {
    return FinancialDetails.name(label: "", value: "", textColor: Colors.transparent);
  }

  Color _successColor(bool isForHeaderCard) {
    return isForHeaderCard ? AppColors.greenOnDarkDefaultColorBg : AppColors.green;
  }

  Color _failureColor(bool isForHeaderCard) {
    return isForHeaderCard ? AppColors.redOnDarkDefaultColorBg : AppColors.red;
  }

  //MARK: Getters

  String getProfileImageUrl() {
    return _currentUserProvider.getCurrentUser().profileImageUrl;
  }

  String getSearchText() {
    return _searchText;
  }

  List<CompanyGroup> getCompanyGroups() {
    return _groupDashboardData!.groups;
  }

  bool shouldShowCompanyGroupsFilter() {
    return _groupDashboardData!.groups.isNotEmpty;
  }

  int getApprovalCount() {
    return _getTotalApprovalCount(_groupDashboardData!);
  }

  int _getTotalApprovalCount(GroupDashboardData dashboardData) {
    num approvalCount = 0;
    for (var i = 0; i < dashboardData.companies.length; i++) {
      approvalCount += dashboardData.companies[i].approvalCount;
    }
    return approvalCount.toInt();
  }
}
