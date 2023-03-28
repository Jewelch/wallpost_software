abstract class HourlySalesView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadReport();

  void showNoHourlySalesMessage();

  void showSalesReportFilter();
}
