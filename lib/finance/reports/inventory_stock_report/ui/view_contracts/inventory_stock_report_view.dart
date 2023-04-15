abstract class InventoryStockReportView {
  void showLoader();

  void onDidFailToLoadAnyData();

  void onDidLoadData();

  void showGetNextDataLoader();

  void onDidLoadNextData();

  void onDidFailToGetNextData();

  void showFilteringInProgressLoader();

  void onDidApplyFiltersSuccessfully();

  void onDidFailToApplyFilters();
}
