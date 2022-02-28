abstract class AttendanceAdjustmentView{
  void showLoader();

  void hideLoader();

  void clearError();

  void onDidLoadAdjustedStatus();

  void onGetAdjustedStatusFailed(String title, String userReadableMessage);

  void notifyInvalidReason(String message);

  void notifyInvalidAdjustedStatus(String title, String userReadableMessage);

  void onAdjustAttendanceSuccess(String title, String message);

  void onAdjustAttendanceFailed(String title, String userReadableMessage);
}