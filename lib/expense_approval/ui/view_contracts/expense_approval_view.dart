abstract class ExpenseApprovalView {
  void onDidFailToApproveOrReject(String title, String message);

  void onDidApproveOrRejectSuccessfully(String expenseId);
}
