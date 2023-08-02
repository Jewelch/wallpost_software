abstract class BalanceSheetView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadBalanceSheet();

  void showFilter();

  void onDidChangeFilters();
}
