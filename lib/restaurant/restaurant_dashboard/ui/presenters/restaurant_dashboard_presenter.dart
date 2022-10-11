import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/date_range_selector/date_range_filters.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/services/aggregated_sales_data_provider.dart';

import '../view_contracts/restaurant_dashboard_view.dart';

class RestaurantDashboardPresenter {
  AggregatedSalesDataProvider _salesDataProvider;
  RestaurantDashboardView _view;
  DateRangeFilters dateFilters;

  RestaurantDashboardPresenter(this._view)
      : _salesDataProvider = AggregatedSalesDataProvider(),
        dateFilters = DateRangeFilters();

  RestaurantDashboardPresenter.initWith(this._view, this._salesDataProvider, this.dateFilters);

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

}
