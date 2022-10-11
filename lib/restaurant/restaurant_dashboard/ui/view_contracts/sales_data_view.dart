import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_data.dart';

abstract class RestaurantDashboardView {
  void showLoader();

  void showErrorMessage(String errorMessage);

  void showSalesData(SalesData salesData);

  void showBottomFilter();
}
