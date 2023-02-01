abstract class HoulySalesView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadReport();

  void showNoItemSalesBreakdownMessage();

  void showSalesReportFilter();

  void onDidChangeFilters();
}
