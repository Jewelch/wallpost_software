
import 'package:wallpost/sales_data/entities/sales_data.dart';

abstract class SalesDataView {
  void showLoader();

  void hideLoader();

  void showErrorMessage(String errorMessage) {}

  void showSalesData(SalesData salesData) {}
}
