import 'package:wallpost/restaurant/restaurant_dashboard/entities/aggregated_sales_data.dart';

abstract class RestaurantDashboardView {
  void showLoader();

  void showErrorMessage(String errorMessage);

  void showSalesData(AggregatedSalesData salesData);

  void showDateRangeSelector();
}
