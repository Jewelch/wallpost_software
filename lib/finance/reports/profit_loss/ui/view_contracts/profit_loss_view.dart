abstract class ProfitsLossesView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadReport();

  void showFilter();

  void onDidChangeFilters();
}
