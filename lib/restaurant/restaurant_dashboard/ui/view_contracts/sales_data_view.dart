import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_data.dart';

abstract class SalesDataView {
  void showLoader();

  void showErrorMessage(String errorMessage) {}

  void showSalesData(SalesData salesData) {}
}
