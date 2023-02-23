abstract class AttendanceAdjustmentApprovalView {
  void showLoader();

  void notifyInvalidRejectionReason(String message);

  void onDidPerformActionSuccessfully(String attendanceAdjustmentId);

  void onDidFailToPerformAction(String title, String message);
}
