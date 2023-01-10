import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/entities/restaurant_dashboard_data.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/services/restaurant_dashboard_data_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../models/manager_dashboard_filters.dart';
import '../models/performance_value.dart';

class RestaurantPerformancePresenter {
  final ModulePerformanceView _view;
  final ManagerDashboardFilters _filters;
  final RestaurantDashboardDataProvider _restaurantDataProvider;
  RestaurantDashboardData? _restaurantData;
  String _errorMessage = "";

  RestaurantPerformancePresenter(this._view, this._filters)
      : _restaurantDataProvider = RestaurantDashboardDataProvider();

  RestaurantPerformancePresenter.initWith(this._view, this._filters, this._restaurantDataProvider);

  Future<void> loadData() async {
    if (_restaurantDataProvider.isLoading) return;

    _resetErrors();
    _restaurantData == null ? _view.showLoader() : _view.onDidLoadData();
    try {
      _restaurantData = await _restaurantDataProvider.get(month: _filters.month, year: _filters.year);
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
      value: _restaurantData!.todaysSale,
      textColor: Colors.white,
    );
  }

  PerformanceValue getYTDSale() {
    return PerformanceValue(
      label: "${AppYears().yearAndMonthAsYtdString(_filters.year, _filters.month)} Sales",
      value: _restaurantData!.ytdSale,
      textColor: Colors.white,
    );
  }

  String get errorMessage => _errorMessage;
}
