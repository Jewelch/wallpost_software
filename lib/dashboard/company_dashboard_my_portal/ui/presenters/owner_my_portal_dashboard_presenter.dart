import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../../../_shared/constants/app_years.dart';
import '../../../../_wp_core/company_management/entities/financial_summary.dart';
import '../../../../_wp_core/company_management/entities/wp_action.dart';
import '../../../../notification_center/notification_center.dart';
import '../../../../notification_center/notification_observer.dart';
import '../../entities/owner_my_portal_data.dart';
import '../../services/owner_my_portal_data_provider.dart';
import '../models/absentees_data.dart';
import '../models/graph_section.dart';
import '../view_contracts/owner_my_portal_view.dart';

class OwnerMyPortalDashboardPresenter {
  final OwnerMyPortalView _view;
  final OwnerMyPortalDataProvider _dataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NotificationCenter _notificationCenter;
  OwnerMyPortalData? _ownerMyPortalData;

  var _selectedYear = AppYears().years().last;
  var _selectedMonth = 0;

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
    if (_dataProvider.isLoading) return;

    _view.showLoader();
    try {
      _ownerMyPortalData = await _dataProvider.get(
        month: _selectedMonth == 0 ? null : _selectedMonth,
        year: _selectedYear,
      );
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void goToAggregatedApprovalsScreen() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    _view.goToApprovalsListScreen(company.id);
  }

  Future<void> setFilter({required int month, required int year}) {
    _selectedMonth = month;
    _selectedYear = year;
    return loadData();
  }

  //MARK: Functions to sync the dashboard data in the background

  Future<void> syncDataInBackground() async {
    if (_ownerMyPortalData == null) return;

    try {
      var existingData = _ownerMyPortalData!;
      var newData = await _dataProvider.get(year: 2022, month: 1);

      if (_didDataChange(existingData, newData)) {
        _ownerMyPortalData = newData;
        _view.onDidLoadData();
      }
    } on WPException catch (_) {
      //do nothing
    }
  }

  bool _didDataChange(OwnerMyPortalData existingData, OwnerMyPortalData newData) {
    return _getTotalApprovalCount(existingData) != _getTotalApprovalCount(newData) ||
        _getAbsenteesData(existingData).numberOfAbsentees != _getAbsenteesData(newData).numberOfAbsentees;
  }

  //MARK: Function to get financial summary

  FinancialSummary getFinancialSummary() {
    return _ownerMyPortalData!.financialSummary;
  }

  //MARK: Function to get absentees data

  AbsenteesData getAbsenteesData() {
    return _getAbsenteesData(_ownerMyPortalData!);
  }

  AbsenteesData _getAbsenteesData(OwnerMyPortalData ownerMyPortalData) {
    if (ownerMyPortalData.absentees > 0) {
      return AbsenteesData(ownerMyPortalData.absentees, AppColors.red);
    } else {
      return AbsenteesData(ownerMyPortalData.absentees, AppColors.green);
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

  //MARK: Functions to get graph values

  List<GraphValue> getCutoffPerformanceGraphSections() {
    return [
      GraphValue(
        _ownerMyPortalData!.lowPerformanceCutoff(),
        AppColors.red.withOpacity(0.3),
      ),
      GraphValue(
        _ownerMyPortalData!.mediumPerformanceCutoff() - _ownerMyPortalData!.lowPerformanceCutoff(),
        AppColors.yellow.withOpacity(0.3),
      ),
      GraphValue(
        100 - _ownerMyPortalData!.mediumPerformanceCutoff(),
        AppColors.green.withOpacity(0.3),
      ),
    ];
  }

  List<GraphValue> getActualPerformanceGraphSections() {
    if (_ownerMyPortalData!.isCompanyPerformanceLow()) {
      return [
        GraphValue(
          _ownerMyPortalData!.companyPerformance.toInt(),
          AppColors.red,
        ),
        GraphValue(
          100 - _ownerMyPortalData!.companyPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    } else if (_ownerMyPortalData!.isCompanyPerformanceMedium()) {
      return [
        GraphValue(
          _ownerMyPortalData!.lowPerformanceCutoff(),
          AppColors.red,
        ),
        GraphValue(
          _ownerMyPortalData!.companyPerformance.toInt() - _ownerMyPortalData!.lowPerformanceCutoff(),
          AppColors.yellow,
        ),
        GraphValue(
          100 - _ownerMyPortalData!.companyPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    } else {
      return [
        GraphValue(
          _ownerMyPortalData!.lowPerformanceCutoff(),
          AppColors.red,
        ),
        GraphValue(
          _ownerMyPortalData!.mediumPerformanceCutoff() - _ownerMyPortalData!.lowPerformanceCutoff(),
          AppColors.yellow,
        ),
        GraphValue(
          _ownerMyPortalData!.companyPerformance.toInt() - _ownerMyPortalData!.mediumPerformanceCutoff(),
          AppColors.green,
        ),
        GraphValue(
          100 - _ownerMyPortalData!.companyPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    }
  }

  GraphValue getCompanyPerformance() {
    if (_ownerMyPortalData!.isCompanyPerformanceLow()) {
      return GraphValue(
        _ownerMyPortalData!.companyPerformance.toInt(),
        AppColors.red,
      );
    } else if (_ownerMyPortalData!.isCompanyPerformanceMedium()) {
      return GraphValue(
        _ownerMyPortalData!.companyPerformance.toInt(),
        AppColors.yellow,
      );
    } else {
      return GraphValue(
        _ownerMyPortalData!.companyPerformance.toInt(),
        AppColors.green,
      );
    }
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

  get selectedMonth => _selectedMonth;

  get selectedYear => _selectedYear;
}
