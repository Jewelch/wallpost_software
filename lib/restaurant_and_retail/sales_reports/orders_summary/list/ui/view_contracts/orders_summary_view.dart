abstract class OrdersSummaryView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadReport();

  void showNoSummaryMessage();

  void showFilter();

  showPaginationLoader() {}
}
