import 'package:flutter/material.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/wp_action.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../../../../_shared/constants/app_colors.dart';
import '../../entities/employee_my_portal_data.dart';
import '../../services/employee_my_portal_data_provider.dart';
import '../models/graph_section.dart';
import '../view_contracts/employee_my_portal_view.dart';

class EmployeeMyPortalDashboardPresenter {
  final EmployeeMyPortalView _view;
  final EmployeeMyPortalDataProvider _dataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  late EmployeeMyPortalData _employeeMyPortalData;

  EmployeeMyPortalDashboardPresenter(this._view)
      : this._dataProvider = EmployeeMyPortalDataProvider(),
        this._selectedCompanyProvider = SelectedCompanyProvider();

  EmployeeMyPortalDashboardPresenter.initWith(
    this._view,
    this._dataProvider,
    this._selectedCompanyProvider,
  );

  Future<void> loadData() async {
    if (_dataProvider.isLoading) return;

    _view.showLoader();
    try {
      _employeeMyPortalData = await _dataProvider.get();
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void goToAggregatedApprovalsScreen() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    _view.goToApprovalsListScreen(company.id);
  }

  //MARK: Function to get approval count

  int getTotalApprovalCount() {
    int totalApprovalCount = 0;
    for (var approval in _employeeMyPortalData.aggregatedApprovals) {
      totalApprovalCount += approval.approvalCount;
    }
    return totalApprovalCount;
  }

  //MARK: Functions to get graph values

  List<GraphValue> getCutoffPerformanceGraphSections() {
    return [
      GraphValue(
        _employeeMyPortalData.lowPerformanceCutoff(),
        AppColors.red.withOpacity(0.3),
      ),
      GraphValue(
        _employeeMyPortalData.mediumPerformanceCutoff() - _employeeMyPortalData.lowPerformanceCutoff(),
        AppColors.yellow.withOpacity(0.3),
      ),
      GraphValue(
        100 - _employeeMyPortalData.mediumPerformanceCutoff(),
        AppColors.green.withOpacity(0.3),
      ),
    ];
  }

  List<GraphValue> getActualPerformanceGraphSections() {
    if (_employeeMyPortalData.isYTDPerformanceLow()) {
      return [
        GraphValue(
          _employeeMyPortalData.ytdPerformance.toInt(),
          AppColors.red,
        ),
        GraphValue(
          100 - _employeeMyPortalData.ytdPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    } else if (_employeeMyPortalData.isYTDPerformanceMedium()) {
      return [
        GraphValue(
          _employeeMyPortalData.lowPerformanceCutoff(),
          AppColors.red,
        ),
        GraphValue(
          _employeeMyPortalData.ytdPerformance.toInt() - _employeeMyPortalData.lowPerformanceCutoff(),
          AppColors.yellow,
        ),
        GraphValue(
          100 - _employeeMyPortalData.ytdPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    } else {
      return [
        GraphValue(
          _employeeMyPortalData.lowPerformanceCutoff(),
          AppColors.red,
        ),
        GraphValue(
          _employeeMyPortalData.mediumPerformanceCutoff() - _employeeMyPortalData.lowPerformanceCutoff(),
          AppColors.yellow,
        ),
        GraphValue(
          _employeeMyPortalData.ytdPerformance.toInt() - _employeeMyPortalData.mediumPerformanceCutoff(),
          AppColors.green,
        ),
        GraphValue(
          100 - _employeeMyPortalData.ytdPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    }
  }

  GraphValue getYTDPerformance() {
    if (_employeeMyPortalData.isYTDPerformanceLow()) {
      return GraphValue(
        _employeeMyPortalData.ytdPerformance.toInt(),
        AppColors.red,
      );
    } else if (_employeeMyPortalData.isYTDPerformanceMedium()) {
      return GraphValue(
        _employeeMyPortalData.ytdPerformance.toInt(),
        AppColors.yellow,
      );
    } else {
      return GraphValue(
        _employeeMyPortalData.ytdPerformance.toInt(),
        AppColors.green,
      );
    }
  }

  GraphValue getCurrentMonthPerformance() {
    if (_employeeMyPortalData.isCurrentMonthPerformanceLow()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthPerformance.toInt(),
        AppColors.red,
      );
    } else if (_employeeMyPortalData.isCurrentMonthPerformanceMedium()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthPerformance.toInt(),
        AppColors.yellow,
      );
    } else {
      return GraphValue(
        _employeeMyPortalData.currentMonthPerformance.toInt(),
        AppColors.green,
      );
    }
  }

  GraphValue getCurrentMonthAttendancePerformance() {
    if (_employeeMyPortalData.isCurrentMonthAttendancePerformanceLow()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthAttendancePerformance.toInt(),
        AppColors.red,
      );
    } else if (_employeeMyPortalData.isCurrentMonthAttendancePerformanceMedium()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthAttendancePerformance.toInt(),
        AppColors.yellow,
      );
    } else {
      return GraphValue(
        _employeeMyPortalData.currentMonthAttendancePerformance.toInt(),
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
}
