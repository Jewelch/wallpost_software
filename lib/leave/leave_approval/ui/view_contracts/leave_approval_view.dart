abstract class LeaveApprovalView {
  void showLoader();

  void notifyInvalidRejectionReason();

  void onDidPerformActionSuccessfully(String leaveId);

  void onDidFailToPerformAction(String title, String message);
}
