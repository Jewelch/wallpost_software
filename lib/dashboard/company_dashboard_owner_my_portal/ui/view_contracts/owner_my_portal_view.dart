abstract class OwnerMyPortalView {
  void showLoader();

  void showErrorMessage(String errorMessage);

  void onDidLoadData();

  void goToApprovalsListScreen(String companyId);

  void showLeaveActions();

  void showExpenseActions();

  void showPayrollAdjustmentActions();
}
