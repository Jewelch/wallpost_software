abstract class FinanceDashBoardView {
  void showLoader();

  void showErrorAndRetryView(String message);

  void onDidLoadFinanceDashBoardData();

  void showFilters();
}
