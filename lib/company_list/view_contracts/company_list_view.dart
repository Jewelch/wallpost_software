abstract class CompaniesListView {
  void showLoader();

  void showErrorMessage(String message);

  void onDidLoadData();

  void updateCompanyList();

  void goToCompanyDetailScreen(String companyId);

  void goToApprovalsListScreen();
}
