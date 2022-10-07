import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/models/owner_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../entities/crm_dashboard_data.dart';
import '../../services/crm_dashboard_data_provider.dart';
import '../models/performance_value.dart';

class CRMPerformancePresenter {
  final ModulePerformanceView _view;
  final OwnerDashboardFilters _filters;
  final CRMDashboardDataProvider _crmDataProvider;
  CRMDashboardData? _crmData;
  String _errorMessage = "";

  CRMPerformancePresenter(this._view, this._filters) : _crmDataProvider = CRMDashboardDataProvider();

  CRMPerformancePresenter.initWith(this._view, this._filters, this._crmDataProvider);

  Future<void> loadData() async {
    if (_crmDataProvider.isLoading) return;

    _resetErrors();
    _crmData == null ? _view.showLoader() : _view.onDidLoadData();
    try {
      _crmData = await _crmDataProvider.get(month: _filters.month, year: _filters.year);
      _view.onDidLoadData();
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.showErrorMessage(e.userReadableMessage);
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Getters

  PerformanceValue getActualRevenue() {
    return PerformanceValue(
      label: "Actual Revenue",
      value: _crmData!.actualRevenue,
      textColor: _crmData!.isActualRevenuePositive() ? AppColors.green : AppColors.red,
    );
  }

  PerformanceValue getTargetAchieved() {
    Color color;
    if (_crmData!.isTargetAchievedPercentHigh()) {
      color = AppColors.green;
    } else if (_crmData!.isTargetAchievedPercentMedium()) {
      color = AppColors.yellow;
    } else {
      color = AppColors.red;
    }

    return PerformanceValue(
      label: "Target Achieved",
      value: "${_crmData!.targetAchievedPercent}%",
      textColor: color,
    );
  }

  PerformanceValue getInPipeline() {
    return PerformanceValue(
      label: "In Pipeline",
      value: _crmData!.inPipeline,
      textColor: AppColors.defaultColorDark,
    );
  }

  PerformanceValue getLeadConverted() {
    Color color;
    if (_crmData!.isLeadConvertedPercentHigh()) {
      color = AppColors.green;
    } else if (_crmData!.isLeadConvertedPercentMedium()) {
      color = AppColors.yellow;
    } else {
      color = AppColors.red;
    }

    return PerformanceValue(
      label: "Lead Converted",
      value: "${_crmData!.leadConvertedPercent}%",
      textColor: color,
    );
  }

  String get errorMessage => _errorMessage;
}
