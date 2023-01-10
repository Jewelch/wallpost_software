import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../entities/hr_dashboard_data.dart';
import '../../services/hr_dashboard_data_provider.dart';
import '../models/manager_dashboard_filters.dart';
import '../models/performance_value.dart';

class HRPerformancePresenter {
  final ModulePerformanceView _view;
  final ManagerDashboardFilters _filters;
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
    Color color;
    if (_hrData!.hasAnyActiveStaff()) {
      color = AppColors.greenOnDarkDefaultColorBg;
    } else {
      color = AppColors.redOnDarkDefaultColorBg;
    }

    return PerformanceValue(
      label: "Active Employees",
      value: _hrData!.activeStaff,
      textColor: color,
    );
  }

  PerformanceValue getStaffOnLeaveToday() {
    Color color;
    if (_hrData!.isAnyStaffOnLeave()) {
      color = AppColors.redOnDarkDefaultColorBg;
    } else {
      color = AppColors.greenOnDarkDefaultColorBg;
    }

    return PerformanceValue(
      label: "Staff On\nLeave",
      value: _hrData!.staffOnLeaveToday,
      textColor: color,
    );
  }

  PerformanceValue getRecruitment() {
    Color color;
    if (_hrData!.isRecruitmentPending()) {
      color = AppColors.redOnDarkDefaultColorBg;
    } else {
      color = AppColors.greenOnDarkDefaultColorBg;
    }

    return PerformanceValue(
      label: "Recruitment\n ",
      value: _hrData!.recruitment,
      textColor: color,
    );
  }

  PerformanceValue getDocumentsExpired() {
    Color color;
    if (_hrData!.areAnyDocumentsExpired()) {
      color = AppColors.redOnDarkDefaultColorBg;
    } else {
      color = AppColors.greenOnDarkDefaultColorBg;
    }

    return PerformanceValue(
      label: "Expired\nDocuments",
      value: _hrData!.documentsExpired,
      textColor: color,
    );
  }

  String get errorMessage => _errorMessage;
}
