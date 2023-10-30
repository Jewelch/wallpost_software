abstract class StocksExpirationView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadReport();

  void showNoStocksMessage();

  void showPaginationLoader();
}
