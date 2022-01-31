abstract class AttendanceView {
  void showLoader();

  void hideLoader();

  void showFailedToLoadAttendance(String title, String message);

  void showDisableButton();

  void showFailedToGetLocation(String title, String message);

  void showLocationAddress(String address);

  void showPunchInButton();

  void showPunchOutButton();

  void showMessageToAllowPunchInFromAppPermission(String message);

  void hideBreakButton();

  void showBreakButton();

  void showResumeButton();

  void showSecondTillPunchIn(String number);

  void showPunchInTime(String time);

  void showPunchOutTime(String time);

  void showAlertToVerifyLocation(String message);

  void doPunchOut();
}
