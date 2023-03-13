abstract class CrmDashboardView {
  void showLoader();

  void onDidLoadData();

  void onDidFailToLoadData(String errorMessage);

  void showYTDFilters(int initialMonth, int initialYear);

  void onDidSetPerformanceTypeFilter();
}
