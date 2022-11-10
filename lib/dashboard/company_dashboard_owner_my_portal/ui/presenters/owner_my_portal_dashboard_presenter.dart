import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../../../_shared/constants/app_years.dart';
import '../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../../../../_wp_core/company_management/entities/wp_action.dart';
import '../../../../notification_center/notification_center.dart';
import '../../../../notification_center/notification_observer.dart';
import '../../../company_dashboard_owner_my_portal/entities/owner_my_portal_data.dart';
import '../../../company_dashboard_owner_my_portal/services/owner_my_portal_data_provider.dart';
import '../models/graph_value.dart';
import '../models/owner_dashboard_filters.dart';
import '../view_contracts/owner_my_portal_view.dart';

class OwnerMyPortalDashboardPresenter {
  final OwnerMyPortalView _view;
  final OwnerMyPortalDataProvider _dataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NotificationCenter _notificationCenter;
  OwnerMyPortalData? _ownerMyPortalData;
  var _filters = OwnerDashboardFilters();

  OwnerMyPortalDashboardPresenter(OwnerMyPortalView view)
      : this.initWith(
          view,
          OwnerMyPortalDataProvider(),
          SelectedCompanyProvider(),
          NotificationCenter.getInstance(),
        );

  OwnerMyPortalDashboardPresenter.initWith(
    this._view,
    this._dataProvider,
    this._selectedCompanyProvider,
    this._notificationCenter,
  ) {
    _startListeningToNotifications();
  }

  //MARK: Functions to start and stop listening to notifications

  void _startListeningToNotifications() {
    _notificationCenter.addExpenseApprovalRequiredObserver(
      NotificationObserver(key: "ownerMyPortal", callback: (_) => syncDataInBackground()),
    );
    _notificationCenter.addLeaveApprovalRequiredObserver(
      NotificationObserver(key: "ownerMyPortal", callback: (_) => syncDataInBackground()),
    );
    _notificationCenter.addAttendanceAdjustmentApprovalRequiredObserver(
      NotificationObserver(key: "ownerMyPortal", callback: (_) => syncDataInBackground()),
    );
  }

  void stopListeningToNotifications() {
    _notificationCenter.removeObserverFromAllChannels(key: "ownerMyPortal");
  }

  //MARK: Functions to load data

  Future<void> loadData() async {
    _view.showLoader();
    try {
      _ownerMyPortalData = await _dataProvider.get(
        month: _filters.month == 0 ? null : _filters.month,
        year: _filters.year,
      );
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Functions to sync the dashboard data in the background

  Future<void> syncDataInBackground() async {
    if (_ownerMyPortalData == null) return;

    try {
      _ownerMyPortalData = await _dataProvider.get(
        month: _filters.month == 0 ? null : _filters.month,
        year: _filters.year,
      );
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.showErrorMessageBanner("Failed to sync updated data.\n${e.userReadableMessage}");
    }
  }

  //MARK: Function to go to aggregated approvals screen

  void goToAggregatedApprovalsScreen() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    _view.goToApprovalsListScreen(company.id);
  }

  //MARK: Function to set filters

  Future<void> setFilter({required int month, required int year}) {
    _filters.month = month;
    _filters.year = year;
    return loadData();
  }

  //MARK: Function to get financial summary

  FinancialSummary getFinancialSummary() {
    return _ownerMyPortalData!.financialSummary;
  }

  //MARK: Function to get company performance

  int getCompanyPerformance() {
    return _ownerMyPortalData!.companyPerformance.toInt();
  }

  String getCompanyPerformanceDisplayValue() {
    return "${getCompanyPerformance()}%";
  }

  String getCompanyPerformanceLabel() {
    return "${AppYears().yearAndMonthAsYtdString(_filters.year, _filters.month)}";
  }

  //MARK: Function to get absentees data

  GraphValue getAbsenteesData() {
    return _getAbsenteesData(_ownerMyPortalData!);
  }

  GraphValue _getAbsenteesData(OwnerMyPortalData ownerMyPortalData) {
    if (ownerMyPortalData.absentees > 0) {
      return GraphValue(ownerMyPortalData.absentees, AppColors.red);
    } else {
      return GraphValue(ownerMyPortalData.absentees, AppColors.green);
    }
  }

  //MARK: Function to get approval count

  int getTotalApprovalCount() {
    return _getTotalApprovalCount(_ownerMyPortalData!);
  }

  int _getTotalApprovalCount(OwnerMyPortalData myPortalData) {
    int totalApprovalCount = 0;
    for (var approval in myPortalData.aggregatedApprovals) {
      totalApprovalCount += approval.approvalCount;
    }
    return totalApprovalCount;
  }

  //MARK: Functions to get and select request items

  List<String> getRequestItems() {
    var employee = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().employee;
    return employee.allowedActions.map((action) => action.toReadableString()).toList();
  }

  void selectRequestItemAtIndex(int index) {
    var employee = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().employee;
    var allowedActions = employee.allowedActions;
    var selectedAction = allowedActions[index];

    switch (selectedAction) {
      case WPAction.Leave:
        _view.showLeaveActions();
        break;
      case WPAction.Expense:
        _view.showExpenseActions();
        break;
      case WPAction.PayrollAdjustment:
        _view.showPayrollAdjustmentActions();
        break;
    }
  }

  //MARK: Getters

  get filters => _filters;

  get selectedMonth => _filters.month;

  get selectedYear => _filters.year;
}
