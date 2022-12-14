abstract class FinanceDasBoardView{
  void showLoader();

  void showErrorAndRetryView(String message);

  void onDidLoadFinanceDashBoardData();

  void showFinanceDashboardFilter();
}