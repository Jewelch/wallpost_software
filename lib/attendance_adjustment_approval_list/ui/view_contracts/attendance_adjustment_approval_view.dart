abstract class AttendanceAdjustmentApprovalView {
  void showLoader();

  void notifyInvalidRejectionReason();

  void onDidPerformActionSuccessfully(String attendanceAdjustmentId);

  void onDidFailToPerformAction(String title, String message);
}
