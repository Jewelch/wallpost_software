import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_wp_core/performance/performance_calculator.dart';
import 'package:wallpost/crm/dashboard/entities/crm_dashboard_data.dart';
import 'package:wallpost/crm/dashboard/entities/service_performance.dart';
import 'package:wallpost/crm/dashboard/entities/staff_performance.dart';
import 'package:wallpost/crm/dashboard/services/crm_dashboard_data_provider.dart';
import 'package:wallpost/crm/dashboard/ui/models/performance_value.dart';

import '../../../../_shared/exceptions/wp_exception.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../models/crm_dashboard_filters.dart';
import '../view_contracts/crm_dashboard_view.dart';
import '../views/widgets/crm_dashboard_no_performance_tile.dart';
import '../views/widgets/crm_dashboard_service_performance_tile.dart';
import '../views/widgets/crm_dashboard_staff_performance_tile.dart';

class CrmDashboardPresenter {
  CrmDashboardView _view;
  CrmDashboardDataProvider _dataProvider;
  SelectedCompanyProvider _selectedCompanyProvider;
  late CrmDashboardData _dashboardData;
  var _filters = CrmDashboardFilters();

  CrmDashboardPresenter(this._view)
      : _dataProvider = CrmDashboardDataProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  CrmDashboardPresenter.initWith(
    this._view,
    this._dataProvider,
    this._selectedCompanyProvider,
  );

  //MARK: Function to load the data

  Future<void> loadData() async {
    if (_dataProvider.isLoading) return;

    _view.showLoader();
    try {
      _dashboardData = await _dataProvider.get(month: _filters.month, year: _filters.year);
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.onDidFailToLoadData(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  //MARK: Function to set and get YTD filters

  void initiateYTDFilterSelection() {
    _view.showYTDFilters(_filters.month, _filters.year);
  }

  Future<void> setYTDFilter({required int month, required int year}) {
    _filters.month = month;
    _filters.year = year;
    return loadData();
  }

  int getSelectedYear() {
    return _filters.year;
  }

  String getSelectedMonthName() {
    if (_filters.month == 0) {
      return "YTD";
    } else {
      return AppYears().getShortNameForMonth(_filters.month);
    }
  }

  //MARK: Functions to set and get performance type filters

  List<String> getPerformanceTypeFilters() {
    return PerformanceType.values.map((e) => e.toReadableString()).toList();
  }

  String getPerformanceFilterNameAtIndex(int index) {
    return getPerformanceTypeFilters()[index];
  }

  void selectPerformanceTypeAtIndex(int index) {
    _filters.performanceType = PerformanceType.values[index];
    _view.onDidSetPerformanceTypeFilter();
  }

  Color getPerformanceFilterBackgroundColor(int index) {
    if (index == PerformanceType.values.indexOf(_filters.performanceType)) {
      return AppColors.defaultColor;
    } else {
      return Colors.white;
    }
  }

  Color getPerformanceFilterTextColor(int index) {
    if (index == PerformanceType.values.indexOf(_filters.performanceType)) {
      return Colors.white;
    } else {
      return AppColors.defaultColor;
    }
  }

  //MARK: Getters

  PerformanceValue getSalesThisYear() {
    return PerformanceValue(
      label: "Sales This Year",
      value: _dashboardData.salesThisYear,
      textColor: AppColors.brightGreen,
      backgroundColor: AppColors.lightGreen,
    );
  }

  PerformanceValue getTargetAchieved() {
    var performancePercent = int.parse(_dashboardData.targetAchievedPercentage);
    Color textColor = PerformanceCalculator().getColorForPerformance(performancePercent);
    Color backgroundColor = PerformanceCalculator().getBackgroundColorForPerformance(performancePercent);

    return PerformanceValue(
      label: "Target Achieved",
      value: "${_dashboardData.targetAchievedPercentage}%",
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  PerformanceValue getInPipeline() {
    return PerformanceValue(
      label: "In Pipeline",
      value: _dashboardData.inPipeline,
      textColor: AppColors.textColorBlack,
      backgroundColor: AppColors.screenBackgroundColor2,
    );
  }

  PerformanceValue getLeadConversion() {
    var performancePercent = int.parse(_dashboardData.leadConversionPercentage);
    Color textColor = PerformanceCalculator().getColorForPerformance(performancePercent);
    Color backgroundColor = PerformanceCalculator().getBackgroundColorForPerformance(performancePercent);

    return PerformanceValue(
      label: "Lead Conversion",
      value: "${_dashboardData.leadConversionPercentage}%",
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  PerformanceValue getSalesGrowth() {
    var performancePercent = int.parse(_dashboardData.salesGrowthPercentage);
    Color textColor = PerformanceCalculator().getColorForPerformance(performancePercent);
    Color backgroundColor = PerformanceCalculator().getBackgroundColorForPerformance(performancePercent);

    return PerformanceValue(
      label: "Sales Growth",
      value: "${_dashboardData.salesGrowthPercentage}%",
      textColor: textColor,
      backgroundColor: backgroundColor,
    );
  }

  int getNumberOfListItems() {
    if (_filters.performanceType == PerformanceType.staffPerformance) {
      return _getNumberOfStaffPerformanceListItems();
    } else {
      return _getNumberOfServicePerformanceListItems();
    }
  }

  Widget getTileForItemAtIndex(int index) {
    if (_filters.performanceType == PerformanceType.staffPerformance) {
      if (_dashboardData.staffPerformances.length == 0)
        return CrmDashboardNoPerformanceTile("There are no staff performances\nfor the selected filters.");

      var staffPerformance = _getStaffPerformanceAtIndex(index);
      return CrmDashboardStaffPerformanceTile(this, staffPerformance);
    } else {
      if (_dashboardData.staffPerformances.length == 0)
        return CrmDashboardNoPerformanceTile("There are no service performances\nfor the selected filters.");

      var servicePerformance = _getServicePerformanceAtIndex(index);
      return CrmDashboardServicePerformanceTile(this, servicePerformance);
    }
  }

  int _getNumberOfStaffPerformanceListItems() {
    return _dashboardData.staffPerformances.length == 0 ? 1 : _dashboardData.staffPerformances.length;
  }

  int _getNumberOfServicePerformanceListItems() {
    return _dashboardData.servicePerformances.length == 0 ? 1 : _dashboardData.servicePerformances.length;
  }

  StaffPerformance _getStaffPerformanceAtIndex(int index) {
    return _dashboardData.staffPerformances[index];
  }

  String getStaffProfileImageUrl(StaffPerformance staffPerformance) {
    return staffPerformance.profileImageUrl;
  }

  String getStaffName(StaffPerformance staffPerformance) {
    return staffPerformance.name;
  }

  String getStaffTargetAmount(StaffPerformance staffPerformance) {
    return staffPerformance.target;
  }

  String getStaffActualAmount(StaffPerformance staffPerformance) {
    return staffPerformance.actual;
  }

  PerformanceValue getStaffPerformancePercentage(StaffPerformance staffPerformance) {
    var performancePercent = int.parse(staffPerformance.performancePercentage);
    Color textColor = PerformanceCalculator().getColorForPerformance(performancePercent);

    return PerformanceValue(
      label: "",
      value: "${staffPerformance.performancePercentage}%",
      textColor: textColor,
      backgroundColor: Colors.white,
    );
  }

  ServicePerformance _getServicePerformanceAtIndex(int index) {
    return _dashboardData.servicePerformances[index];
  }

  String getServiceName(ServicePerformance servicePerformance) {
    return servicePerformance.name;
  }

  String getServiceTargetAmount(ServicePerformance servicePerformance) {
    return servicePerformance.target;
  }

  String getServiceActualAmount(ServicePerformance servicePerformance) {
    return servicePerformance.actual;
  }

  PerformanceValue getServicePerformancePercentage(ServicePerformance servicePerformance) {
    var performancePercent = int.parse(servicePerformance.performancePercentage);
    Color textColor = PerformanceCalculator().getColorForPerformance(performancePercent);

    return PerformanceValue(
      label: "",
      value: "${servicePerformance.performancePercentage}%",
      textColor: textColor,
      backgroundColor: Colors.white,
    );
  }

  String getCurrency() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
  }

  String getCompanyName() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;
  }
}
