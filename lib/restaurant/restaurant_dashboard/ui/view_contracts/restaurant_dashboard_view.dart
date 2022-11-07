abstract class RestaurantDashboardView {
  void showLoader();

  void showErrorMessage(String errorMessage);

  void updateSalesData();

  void showSalesBreakDowns();

  void showDateRangeSelector();

  void onDidChangeSalesBreakDownWise();
}
