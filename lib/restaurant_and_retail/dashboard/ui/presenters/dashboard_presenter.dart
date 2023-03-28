import 'package:flutter/material.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../../../../_shared/date_range_selector/entities/date_range.dart';
import '../../../../_shared/exceptions/wp_exception.dart';
import '../../../../_shared/extensions/string_extensions.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/aggregated_sales_data.dart';
import '../../entities/sales_break_down_item.dart';
import '../../entities/sales_break_down_wise_options.dart';
import '../../services/aggregated_sales_data_provider.dart';
import '../../services/sales_breakdowns_provider.dart';
import '../models/performance_value.dart';
import '../view_contracts/dashboard_view.dart';
import '../views/screens/dashboard_screen.dart';

class DashboardPresenter {
  DashboardView _view;
  AggregatedSalesDataProvider _salesDataProvider;
  SalesBreakDownsProvider _salesBreakDownsProvider;
  SelectedCompanyProvider _selectedCompanyProvider;

  AggregatedSalesData? _salesData;
  List<SalesBreakDownItem> _salesBreakdownItems = [];
  DateRange dateFilters;
  SalesBreakDownWiseOptions _selectedBreakDownWise = SalesBreakDownWiseOptions.basedOnCategory;
  final DashboardContext dashboardContext;

  DashboardPresenter(this._view, {required this.dashboardContext})
      : _salesDataProvider = AggregatedSalesDataProvider(dashboardContext: dashboardContext),
        _salesBreakDownsProvider = SalesBreakDownsProvider(dashboardContext: dashboardContext),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        dateFilters = DateRange();

  DashboardPresenter.initWith(
    this.dashboardContext,
    this._view,
    this._salesDataProvider,
    this._salesBreakDownsProvider,
    this.dateFilters,
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

  bool breakdownsListIsEmpty() => _salesBreakdownItems.isEmpty;

  List<SalesBreakDownWiseOptions> getSalesBreakdownFilters() {
    if (dashboardContext == DashboardContext.restaurant) {
      return SalesBreakDownWiseOptions.values;
    } else {
      return [SalesBreakDownWiseOptions.basedOnCategory, SalesBreakDownWiseOptions.basedOnMenu];
    }
  }

  String getSalesBreakDownFilterName(SalesBreakDownWiseOptions salesBreakdownOption) =>
      salesBreakdownOption.toReadableString();

  Color getSalesBreakdownFilterBackgroundColor(SalesBreakDownWiseOptions salesBreakdownOption) =>
      salesBreakdownOption == selectedBreakDownWise ? AppColors.defaultColor : AppColors.filtersBackgroundColor;

  Color getSalesBreakdownFilterTextColor(SalesBreakDownWiseOptions salesBreakdownOption) =>
      salesBreakdownOption == selectedBreakDownWise ? Colors.white : AppColors.defaultColor;

  //MARK: Functions to apply sales breakdown type filter

  void selectSalesBreakDownFilter(SalesBreakDownWiseOptions breakdownOption) {
    _selectedBreakDownWise = breakdownOption;
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

  String getSalesBreakdownValue(int index) => getBreakdownAtIndex(index).value;
}
