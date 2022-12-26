abstract class ItemSalesView {
  void showLoader();

  void showSalesReportFilter();

  void showErrorMessage(String message);

  void onDidChangeFilters();

  void showItemSalesBreakDowns();

  void updateItemSalesData();

  void showNoItemSalesBreakdownMessage();
}
