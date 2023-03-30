abstract class PurchaseBillApprovalView {
  void showLoader();

  void notifyInvalidRejectionReason(String message);

  void onDidPerformActionSuccessfully(String billId);

  void onDidFailToPerformAction(String title, String message);
}
