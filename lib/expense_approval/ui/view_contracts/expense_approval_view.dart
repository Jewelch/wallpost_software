abstract class ExpenseApprovalView {
  void showLoader();

  void notifyInvalidRejectionReason();

  void onDidPerformActionSuccessfully(String expenseId);

  void onDidFailToPerformAction(String title, String message);
}
