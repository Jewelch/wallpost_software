import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../entities/hr_dashboard_data.dart';
import '../../services/hr_dashboard_data_provider.dart';
import '../models/owner_dashboard_filters.dart';
import '../models/performance_value.dart';

class HRPerformancePresenter {
  final ModulePerformanceView _view;
  final OwnerDashboardFilters _filters;
  final HRDashboardDataProvider _hrDataProvider;
  HRDashboardData? _hrData;
  String _errorMessage = "";

  HRPerformancePresenter(this._view, this._filters) : _hrDataProvider = HRDashboardDataProvider();

  HRPerformancePresenter.initWith(this._view, this._filters, this._hrDataProvider);

  Future<void> loadData() async {
    if (_hrDataProvider.isLoading) return;

    _resetErrors();
    _hrData == null ? _view.showLoader() : _view.onDidLoadData();
    try {
      _hrData = await _hrDataProvider.get(month: _filters.month, year: _filters.year);
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

  PerformanceValue getActiveStaff() {
    return PerformanceValue(
      label: "Active Staff",
      value: _hrData!.activeStaff,
      textColor: AppColors.textColorBlack,
    );
  }

  PerformanceValue getEmployeeCost() {
    return PerformanceValue(
      label: "Employee Cost",
      value: _hrData!.employeeCost,
      textColor: AppColors.textColorBlack,
    );
  }

  PerformanceValue getStaffOnLeaveToday() {
    return PerformanceValue(
      label: "Staff On Leave",
      value: _hrData!.staffOnLeaveToday,
      textColor: AppColors.textColorBlack,
    );
  }

  PerformanceValue getDocumentsExpired() {
    Color color;
    if (_hrData!.areAnyDocumentsExpired()) {
      color = AppColors.red;
    } else {
      color = AppColors.green;
    }

    return PerformanceValue(
      label: "Expired Documents",
      value: _hrData!.documentsExpired,
      textColor: color,
    );
  }

  String get errorMessage => _errorMessage;
}
