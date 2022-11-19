abstract class RestaurantDashboardView {
  void showLoader();

  void showLoadingForSalesBreakDowns();

  void showErrorMessage(String errorMessage);

  void updateSalesData();

  void showSalesBreakDowns();

  void showDateRangeSelector();

  void onDidChangeSalesBreakDownWise();
}
