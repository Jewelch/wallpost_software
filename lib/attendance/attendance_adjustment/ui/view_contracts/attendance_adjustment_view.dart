abstract class AttendanceAdjustmentView {
  void showAdjustedStatusLoader();

  void updateAdjustedPunchInAndOutTime();

  void onDidFailToLoadAdjustedStatus(String title, String message);

  void onDidLoadAdjustedStatus();

  void notifyNoAdjustmentMade();

  void notifyInvalidReason();

  void clearAdjustedTimeInputError();

  void clearReasonInputError();

  void showFormSubmissionLoader();

  void onDidFailToAdjustAttendance(String title, String message);

  void onDidAdjustAttendanceSuccessfully(String title, String message);
}
