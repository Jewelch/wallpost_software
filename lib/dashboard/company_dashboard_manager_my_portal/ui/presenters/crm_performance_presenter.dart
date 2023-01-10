import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/performance/performance_calculator.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/models/manager_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../entities/crm_dashboard_data.dart';
import '../../services/crm_dashboard_data_provider.dart';
import '../models/performance_value.dart';

class CRMPerformancePresenter {
  final ModulePerformanceView _view;
  final ManagerDashboardFilters _filters;
  final CRMDashboardDataProvider _crmDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  CRMDashboardData? _crmData;
  String _errorMessage = "";

  CRMPerformancePresenter(this._view, this._filters)
      : _crmDataProvider = CRMDashboardDataProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  CRMPerformancePresenter.initWith(
    this._view,
    this._filters,
    this._crmDataProvider,
    this._selectedCompanyProvider,
  );

  Future<void> loadData() async {
    if (_crmDataProvider.isLoading) return;

    _resetErrors();
    _crmData == null ? _view.showLoader() : _view.onDidLoadData();
    try {
      _crmData = await _crmDataProvider.get(month: _filters.month, year: _filters.year);
      _view.onDidLoadData();
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.showErrorMessage();
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Getters

  PerformanceValue getActualRevenue() {
    return PerformanceValue(
      label: "Actual Revenue (${_selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency})",
      value: _crmData!.actualRevenue,
      textColor:
          _crmData!.isActualRevenuePositive() ? AppColors.greenOnDarkDefaultColorBg : AppColors.redOnDarkDefaultColorBg,
    );
  }

  PerformanceValue getTargetAchieved() {
    return PerformanceValue(
      label: "Target\nAchieved",
      value: "${_crmData!.targetAchievedPercent}%",
      textColor:
          PerformanceCalculator().getColorForPerformance(_crmData!.targetAchievedPercent, isOnDefaultBackground: true),
    );
  }

  PerformanceValue getInPipeline() {
    return PerformanceValue(
      label: "In\nPipeline",
      value: _crmData!.inPipeline,
      textColor: Colors.white,
    );
  }

  PerformanceValue getLeadConverted() {
    return PerformanceValue(
      label: "Lead\nConverted",
      value: "${_crmData!.leadConvertedPercent}%",
      textColor:
          PerformanceCalculator().getColorForPerformance(_crmData!.leadConvertedPercent, isOnDefaultBackground: true),
    );
  }

  String get errorMessage => _errorMessage;
}
