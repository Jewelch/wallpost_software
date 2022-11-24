import 'package:flutter/material.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/aggregated_sales_data_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/sales_breakdowns_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/models/performance_value.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../../entities/aggregated_sales_data.dart';
import '../../entities/sales_break_down_item.dart';
import '../view_contracts/restaurant_dashboard_view.dart';

class RestaurantDashboardPresenter {
  RestaurantDashboardView _view;
  AggregatedSalesDataProvider _salesDataProvider;
  SalesBreakDownsProvider _salesBreakDownsProvider;
  CurrentUserProvider _currentUserProvider;
  SelectedCompanyProvider _selectedCompanyProvider;

  AggregatedSalesData? _salesData;
  List<SalesBreakDownItem> _salesBreakdownItems = [];
  DateRangeFilters dateFilters;
  SalesBreakDownWiseOptions _selectedBreakDownWise = SalesBreakDownWiseOptions.basedOnCategory;

  RestaurantDashboardPresenter(this._view)
      : _salesDataProvider = AggregatedSalesDataProvider(),
        _salesBreakDownsProvider = SalesBreakDownsProvider(),
        _currentUserProvider = CurrentUserProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        dateFilters = DateRangeFilters();

  RestaurantDashboardPresenter.initWith(
    this._view,
    this._salesDataProvider,
    this._salesBreakDownsProvider,
    this.dateFilters,
    this._currentUserProvider,
    this._selectedCompanyProvider,
  );

  //MARK: Load Aggregated Sales Data

  Future loadAggregatedSalesData() async {
    if (_salesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      _salesData = await _salesDataProvider.getSalesAmounts(dateFilters);
      _view.updateSalesData();
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  //MARK: Load Sales BreakDowns Data

  Future loadSalesBreakDown({required bool singleTask}) async {
    if (_salesBreakDownsProvider.isLoading) return;

    singleTask ? _view.showLoadingForSalesBreakDowns() : _view.showLoader();

    try {
      _salesBreakdownItems = await _salesBreakDownsProvider.getSalesBreakDowns(
        _selectedBreakDownWise,
        dateFilters,
      );
      sortBreakdownItemsFromHighSalesToLow();
      _salesBreakdownItems.isNotEmpty ? _view.showSalesBreakDowns() : _view.showNoSalesBreakdownMessage();
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  void sortBreakdownItemsFromHighSalesToLow() {
    _salesBreakdownItems..sort((a, b) => b.totalSales.compareTo(a.totalSales));
  }

  //MARK: Gets sales breakdown list data

  int getNumberOfBreakdowns() => _salesBreakdownItems.length;

  PerformanceValue getBreakdownAtIndex(int index) => PerformanceValue(
        label: _salesBreakdownItems[index].type,
        value: _salesBreakdownItems[index].totalSalesDisplayValue,
        textColor: AppColors.textColorBlack,
      );

  //MARK: Function to initiate filter selection

  void onFiltersGotClicked() {
    _view.showRestaurantDashboardFilter();
  }

  //MARK: Functions to get the sales breakdown type filter data

  String getSalesBreakDownFilterName(int index) => SalesBreakDownWiseOptions.values[index].toReadableString();

  Color getSalesBreakdownFilterBackgroundColor(int index) =>
      SalesBreakDownWiseOptions.values[index] == selectedBreakDownWise
          ? AppColors.defaultColor
          : AppColors.filtersBackgroundColor;

  Color getSalesBreakdownFilterTextColor(int index) =>
      SalesBreakDownWiseOptions.values[index] == selectedBreakDownWise ? Colors.white : AppColors.defaultColor;

  //MARK: Functions to apply sales breakdown type filter

  void selectSalesBreakDownWiseAtIndex(int index) {
    _selectedBreakDownWise = SalesBreakDownWiseOptions.values[index];
    _view.onDidChangeSalesBreakDownWise();
  }

  //MARK: Aggregated sales data getters

  String getTotalSales() => _salesData?.totalSales ?? "0.00";

  String getNetSale() => _salesData?.netSales ?? "0.00";

  String getCostOfSales() => _salesData?.costOfSales ?? "0.00";

  String getGrossProfit() => (_salesData?.grossOfProfit ?? "0.00") + "%";

  Color getGrossProfitTextColor() => (_salesData?.grossOfProfit ?? "0.00").isNegative ? AppColors.red : AppColors.green;

  // Getters

  SalesBreakDownWiseOptions get selectedBreakDownWise => _selectedBreakDownWise;

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;

  String getProfileImageUrl() => _currentUserProvider.getCurrentUser().profileImageUrl;
}
