import 'package:flutter/material.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';

import '../../../_shared/constants/app_colors.dart';
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
      _view.showErrorMessage(e.userReadableMessage);
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
        AppColors.graphLowValueColor.withOpacity(0.3),
      ),
      GraphValue(
        _employeeMyPortalData.mediumPerformanceCutoff() - _employeeMyPortalData.lowPerformanceCutoff(),
        AppColors.graphMediumValueColor.withOpacity(0.3),
      ),
      GraphValue(
        100 - _employeeMyPortalData.mediumPerformanceCutoff(),
        AppColors.graphHighValueColor.withOpacity(0.3),
      ),
    ];
  }

  List<GraphValue> getActualPerformanceGraphSections() {
    if (_employeeMyPortalData.isYTDPerformanceLow()) {
      return [
        GraphValue(
          _employeeMyPortalData.ytdPerformance.toInt(),
          AppColors.graphLowValueColor,
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
          AppColors.graphLowValueColor,
        ),
        GraphValue(
          _employeeMyPortalData.ytdPerformance.toInt() - _employeeMyPortalData.lowPerformanceCutoff(),
          AppColors.graphMediumValueColor,
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
          AppColors.graphLowValueColor,
        ),
        GraphValue(
          _employeeMyPortalData.mediumPerformanceCutoff() - _employeeMyPortalData.lowPerformanceCutoff(),
          AppColors.graphMediumValueColor,
        ),
        GraphValue(
          _employeeMyPortalData.ytdPerformance.toInt() - _employeeMyPortalData.mediumPerformanceCutoff(),
          AppColors.graphHighValueColor,
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
        AppColors.graphLowValueColor,
      );
    } else if (_employeeMyPortalData.isYTDPerformanceMedium()) {
      return GraphValue(
        _employeeMyPortalData.ytdPerformance.toInt(),
        AppColors.graphMediumValueColor,
      );
    } else {
      return GraphValue(
        _employeeMyPortalData.ytdPerformance.toInt(),
        AppColors.graphHighValueColor,
      );
    }
  }

  GraphValue getCurrentMonthPerformance() {
    if (_employeeMyPortalData.isCurrentMonthPerformanceLow()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthPerformance.toInt(),
        AppColors.graphLowValueColor,
      );
    } else if (_employeeMyPortalData.isCurrentMonthPerformanceMedium()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthPerformance.toInt(),
        AppColors.graphMediumValueColor,
      );
    } else {
      return GraphValue(
        _employeeMyPortalData.currentMonthPerformance.toInt(),
        AppColors.graphHighValueColor,
      );
    }
  }

  GraphValue getCurrentMonthAttendancePerformance() {
    if (_employeeMyPortalData.isCurrentMonthAttendancePerformanceLow()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthAttendancePerformance.toInt(),
        AppColors.graphLowValueColor,
      );
    } else if (_employeeMyPortalData.isCurrentMonthAttendancePerformanceMedium()) {
      return GraphValue(
        _employeeMyPortalData.currentMonthAttendancePerformance.toInt(),
        AppColors.graphMediumValueColor,
      );
    } else {
      return GraphValue(
        _employeeMyPortalData.currentMonthAttendancePerformance.toInt(),
        AppColors.graphHighValueColor,
      );
    }
  }
}
