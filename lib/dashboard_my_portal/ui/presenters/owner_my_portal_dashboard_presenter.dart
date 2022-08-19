import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/dashboard_my_portal/entities/owner_my_portal_data.dart';
import 'package:wallpost/dashboard_my_portal/services/owner_my_portal_data_provider.dart';
import 'package:wallpost/dashboard_my_portal/ui/models/absentees_data.dart';
import 'package:wallpost/dashboard_my_portal/ui/models/graph_section.dart';
import 'package:wallpost/dashboard_my_portal/ui/view_contracts/owner_my_portal_view.dart';

class OwnerMyPortalDashboardPresenter {
  final OwnerMyPortalView _view;
  final OwnerMyPortalDataProvider _dataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  late OwnerMyPortalData _ownerMyPortalData;

  OwnerMyPortalDashboardPresenter(this._view)
      : this._dataProvider = OwnerMyPortalDataProvider(),
        this._selectedCompanyProvider = SelectedCompanyProvider();

  OwnerMyPortalDashboardPresenter.initWith(
    this._view,
    this._dataProvider,
    this._selectedCompanyProvider,
  );

  Future<void> loadData() async {
    if (_dataProvider.isLoading) return;

    _view.showLoader();
    try {
      _ownerMyPortalData = await _dataProvider.get();
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage);
    }
  }

  void goToAggregatedApprovalsScreen() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    _view.goToApprovalsListScreen(company.id);
  }

  //MARK: Function to get financial summary

  FinancialSummary getFinancialSummary() {
    return _ownerMyPortalData.financialSummary;
  }

  //MARK: Function to get absentees data

  AbsenteesData getAbsenteesData() {
    if (_ownerMyPortalData.absentees > 0) {
      return AbsenteesData(_ownerMyPortalData.absentees, AppColors.failureColor);
    } else {
      return AbsenteesData(_ownerMyPortalData.absentees, AppColors.successColor);
    }
  }

  //MARK: Function to get approval count

  int getTotalApprovalCount() {
    int totalApprovalCount = 0;
    for (var approval in _ownerMyPortalData.aggregatedApprovals) {
      totalApprovalCount += approval.approvalCount;
    }
    return totalApprovalCount;
  }

  //MARK: Functions to get graph values

  List<GraphValue> getCutoffPerformanceGraphSections() {
    return [
      GraphValue(
        _ownerMyPortalData.lowPerformanceCutoff(),
        AppColors.graphLowValueColor.withOpacity(0.3),
      ),
      GraphValue(
        _ownerMyPortalData.mediumPerformanceCutoff() - _ownerMyPortalData.lowPerformanceCutoff(),
        AppColors.graphMediumValueColor.withOpacity(0.3),
      ),
      GraphValue(
        100 - _ownerMyPortalData.mediumPerformanceCutoff(),
        AppColors.graphHighValueColor.withOpacity(0.3),
      ),
    ];
  }

  List<GraphValue> getActualPerformanceGraphSections() {
    if (_ownerMyPortalData.isCompanyPerformanceLow()) {
      return [
        GraphValue(
          _ownerMyPortalData.companyPerformance.toInt(),
          AppColors.graphLowValueColor,
        ),
        GraphValue(
          100 - _ownerMyPortalData.companyPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    } else if (_ownerMyPortalData.isCompanyPerformanceMedium()) {
      return [
        GraphValue(
          _ownerMyPortalData.lowPerformanceCutoff(),
          AppColors.graphLowValueColor,
        ),
        GraphValue(
          _ownerMyPortalData.companyPerformance.toInt() - _ownerMyPortalData.lowPerformanceCutoff(),
          AppColors.graphMediumValueColor,
        ),
        GraphValue(
          100 - _ownerMyPortalData.companyPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    } else {
      return [
        GraphValue(
          _ownerMyPortalData.lowPerformanceCutoff(),
          AppColors.graphLowValueColor,
        ),
        GraphValue(
          _ownerMyPortalData.mediumPerformanceCutoff() - _ownerMyPortalData.lowPerformanceCutoff(),
          AppColors.graphMediumValueColor,
        ),
        GraphValue(
          _ownerMyPortalData.companyPerformance.toInt() - _ownerMyPortalData.mediumPerformanceCutoff(),
          AppColors.graphHighValueColor,
        ),
        GraphValue(
          100 - _ownerMyPortalData.companyPerformance.toInt(),
          Colors.transparent,
        ),
      ];
    }
  }

  GraphValue getCompanyPerformance() {
    if (_ownerMyPortalData.isCompanyPerformanceLow()) {
      return GraphValue(
        _ownerMyPortalData.companyPerformance.toInt(),
        AppColors.graphLowValueColor,
      );
    } else if (_ownerMyPortalData.isCompanyPerformanceMedium()) {
      return GraphValue(
        _ownerMyPortalData.companyPerformance.toInt(),
        AppColors.graphMediumValueColor,
      );
    } else {
      return GraphValue(
        _ownerMyPortalData.companyPerformance.toInt(),
        AppColors.graphHighValueColor,
      );
    }
  }
}
