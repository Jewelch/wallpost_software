import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_wise_options.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/aggregated_sales_data_provider.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/sales_breakdowns_provider.dart';

import '../view_contracts/restaurant_dashboard_view.dart';

class RestaurantDashboardPresenter {
  AggregatedSalesDataProvider _salesDataProvider;
  SalesBreakDownsProvider _salesBreakDownsProvider;
  RestaurantDashboardView _view;
  DateRangeFilters dateFilters;

  RestaurantDashboardPresenter(this._view)
      : _salesDataProvider = AggregatedSalesDataProvider(),
        _salesBreakDownsProvider = SalesBreakDownsProvider(),
        dateFilters = DateRangeFilters();

  RestaurantDashboardPresenter.initWith(
    this._view,
    this._salesDataProvider,
    this._salesBreakDownsProvider,
    this.dateFilters,
  );

  SalesBreakDownWiseOptions _selectedBreakDownWise = SalesBreakDownWiseOptions.values.first;

  SalesBreakDownWiseOptions get selectedBreakDownWise => _selectedBreakDownWise;

  // MARK: Load Aggregated Sales Data

  Future loadSalesData() async {
    if (_salesDataProvider.isLoading) return;

    _view.showLoader();
    try {
      var salesData = await _salesDataProvider.getSalesAmounts(dateFilters);
      _view.showSalesData(salesData);
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  // MARK: Change Sales BreakDowns Data

  void selectSalesBreakDownWiseAtIndex(int index) {
    _selectedBreakDownWise = SalesBreakDownWiseOptions.values[index];
    _view.onDidSelectSalesBreakdownFilteringStrategy();
  }

  // MARK: Load Sales BreakDowns Data

  Future loadSalesBreakDown() async {
    if (_salesBreakDownsProvider.isLoading) return;

    _view.showLoader();
    try {
      var salesBreakDowns = await _salesBreakDownsProvider.getSalesBreakDowns(_selectedBreakDownWise);
      _view.showSalesBreakDowns(salesBreakDowns);
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }
}
