import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';

abstract class RestaurantDashboardView {
  void showLoader();

  void showErrorMessage(String errorMessage);

  void showSalesData(AggregatedSalesData salesData);

  void showSalesBreakDowns(List<SalesBreakDownItem> salesBreakDowns);

  void showDateRangeSelector();

  void onDidSelectSalesBreakdownFilteringStrategy();
}
