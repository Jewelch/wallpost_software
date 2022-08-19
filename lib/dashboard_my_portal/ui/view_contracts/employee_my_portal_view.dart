abstract class EmployeeMyPortalView {
  void showLoader();

  void showErrorMessage(String errorMessage);

  void onDidLoadData();

  void goToApprovalsListScreen(String companyId);
}
