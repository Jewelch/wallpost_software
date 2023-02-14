abstract class ExpenseApprovalView {
  void showLoader();

  void notifyInvalidRejectionReason(String message);

  void onDidPerformActionSuccessfully(String expenseId);

  void onDidFailToPerformAction(String title, String message);
}
