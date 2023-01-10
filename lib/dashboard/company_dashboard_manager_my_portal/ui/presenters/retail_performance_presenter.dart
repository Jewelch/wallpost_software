import 'package:flutter/material.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../../../_shared/constants/app_years.dart';
import '../../entities/retail_dashboard_data.dart';
import '../../services/retail_dashboard_data_provider.dart';
import '../models/manager_dashboard_filters.dart';
import '../models/performance_value.dart';

class RetailPerformancePresenter {
  final ModulePerformanceView _view;
  final ManagerDashboardFilters _filters;
  final RetailDashboardDataProvider _retailDataProvider;
  RetailDashboardData? _retailData;
  String _errorMessage = "";

  RetailPerformancePresenter(this._view, this._filters) : _retailDataProvider = RetailDashboardDataProvider();

  RetailPerformancePresenter.initWith(this._view, this._filters, this._retailDataProvider);

  Future<void> loadData() async {
    if (_retailDataProvider.isLoading) return;

    _resetErrors();
    _retailData == null ? _view.showLoader() : _view.onDidLoadData();
    try {
      _retailData = await _retailDataProvider.get(month: _filters.month, year: _filters.year);
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

  PerformanceValue getTodaysSale() {
    return PerformanceValue(
      label: "Today's Sales",
      value: _retailData!.todaysSale,
      textColor: Colors.white,
    );
  }

  PerformanceValue getYTDSale() {
    return PerformanceValue(
      label: "${AppYears().yearAndMonthAsYtdString(_filters.year, _filters.month)} Sales",
      value: _retailData!.ytdSale,
      textColor: Colors.white,
    );
  }

  String get errorMessage => _errorMessage;
}
