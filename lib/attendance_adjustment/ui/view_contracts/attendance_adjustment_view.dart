abstract class AttendanceAdjustmentView{
  void showLoader();

  void hideLoader();

  void clearError();

  void notifyInvalidReason(String message);

  void notifyInvalidAdjustedStatus(String title, String userReadableMessage);

  void onAdjustAttendanceSuccess(String title, String message);

  void onGetAdjustedStatusFailed(String title, String userReadableMessage);

  void onAdjustAttendanceFailed(String title, String userReadableMessage);
}