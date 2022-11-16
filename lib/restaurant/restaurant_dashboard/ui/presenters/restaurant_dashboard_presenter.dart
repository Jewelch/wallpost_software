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
  late double _maxBreakdownSale;
  late double _minBreakdownSale;
  DateRangeFilters dateFilters;
  SalesBreakDownWiseOptions _selectedBreakDownWise = SalesBreakDownWiseOptions.values.first;

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

  // MARK: Load Aggregated Sales Data

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

  // MARK: Load Sales BreakDowns Data

  Future loadSalesBreakDown({required bool singleTask}) async {
    if (_salesBreakDownsProvider.isLoading) return;

    singleTask ? _view.showLloadingForSalesBreakDowns() : _view.showLoader();

    try {
      _salesBreakdownItems = await _salesBreakDownsProvider.getSalesBreakDowns(
        _selectedBreakDownWise,
        dateFilters,
      );
      sortBreakdownItemsFromHighSalesToLow();
      initMaxAndMinBreakdownSales();
      _view.showSalesBreakDowns();
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  void sortBreakdownItemsFromHighSalesToLow() => _salesBreakdownItems
    ..sort(
      (a, b) => b.totalSales.toDouble.compareTo(a.totalSales.toDouble),
    );

  void initMaxAndMinBreakdownSales() {
    double _maxSale = 0;
    double _minSale = double.maxFinite;
    for (var sales in _salesBreakdownItems) {
      if (sales.totalSales.toDouble > _maxSale) {
        _maxSale = sales.totalSales.toDouble;
      } else if (sales.totalSales.toDouble < _minSale) {
        _minSale = sales.totalSales.toDouble;
      }
    }
    _maxBreakdownSale = _maxSale;
    _minBreakdownSale = _minSale;
  }

  //MARK: Gets sales breakdown list data
  int getNumberOfBreakdowns() => _salesBreakdownItems.length;

  //MARK: Checks if sales breakdown list data is empty
  bool breakdownsIsEmpty() => _salesBreakdownItems.isEmpty;

// MARK: Gets readable string for sales breakdown wise option
  String getSalesBreakDownWiseOptions(int index) => SalesBreakDownWiseOptions.values[index].toReadableString();

  PerformanceValue getBreakdownAtIndex(int index) => PerformanceValue(
        label: _salesBreakdownItems[index].type,
        value: _salesBreakdownItems[index].totalSales.withoutNullDecimals.commaSeparated,
        textColor: _getSalesBreakDownItemColor(_salesBreakdownItems[index]),
      );

  Color _getSalesBreakDownItemColor(SalesBreakDownItem salesBreakDownItem) {
    if (salesBreakDownItem.totalSales.toDouble == _maxBreakdownSale) return AppColors.green;
    if (salesBreakDownItem.totalSales.toDouble == _minBreakdownSale) return AppColors.red;
    return AppColors.yellow;
  }

  // MARK: Changes sales breakdown filtering wise
  void selectSalesBreakDownWiseAtIndex(int index) {
    _selectedBreakDownWise = SalesBreakDownWiseOptions.values[index];
    _view.onDidChangeSalesBreakDownWise();
  }

  String getSalesBreakdownValue(int index) => getBreakdownAtIndex(index).value;
  String getSalesBreakdownLabel(int index) => getBreakdownAtIndex(index).label;

  Color getSalesBreakdownChipColor(int index) => SalesBreakDownWiseOptions.values[index] == selectedBreakDownWise
      ? AppColors.defaultColor
      : AppColors.filtersBackgroundColor;

  Color getSalesBreakdownTextColor(int index) =>
      SalesBreakDownWiseOptions.values[index] == selectedBreakDownWise ? Colors.white : AppColors.defaultColor;

  // Getters

  SalesBreakDownWiseOptions get selectedBreakDownWise => _selectedBreakDownWise;

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getProfileImageUrl() => _currentUserProvider.getCurrentUser().profileImageUrl;

  String getTotalSales() => _salesData?.totalSales ?? "0.00";

  String getNetSale() => _salesData?.netSales ?? "0.00";

  String getCostOfSales() => _salesData?.costOfSales ?? "0.00";

  String getGrossProfit() => (_salesData?.grossOfProfit ?? "0.00") + "%";

  Color getGrossProfitTextColor() => (_salesData?.grossOfProfit ?? "0.00").isNegative ? AppColors.red : AppColors.green;
}
