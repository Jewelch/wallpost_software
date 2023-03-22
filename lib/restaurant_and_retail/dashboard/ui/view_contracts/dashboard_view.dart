
abstract class DashboardView {
  void showLoader();

  void showLoadingForSalesBreakDowns();

  void showErrorMessage(String errorMessage);

  void updateSalesData();

  void showNoSalesBreakdownMessage();

  void showSalesBreakDowns();

  void showDateRangeSelector();

  void onDidChangeSalesBreakDownWise();

  void showRestaurantDashboardFilter();
}
