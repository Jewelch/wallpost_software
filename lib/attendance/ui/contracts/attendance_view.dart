abstract class AttendanceView {
  void showLoader();

  void hideLoader();

  void showPunchInButton();

  void showPunchOutButton();

  void showDisableButton();

  void hideBreakButton();

  void showBreakButton();

  void showResumeButton();

  void showPunchInTime(String time);

  void showPunchOutTime(String time);

  void showSecondTillPunchIn(String number);

  void showLocationAddress(String address);

  void showFailedToLoadAttendance(String title, String message);

  void showFailedToGetLocation(String title, String message);

  void showAlertToVerifyLocation(String message);

  void showAlertToTurnOnDeviceLocation(String title, String message);

  void showAlertToDeniedLocationPermission(String title, String message);

  void showMessageToAllowPunchInFromAppPermission(String message);

  void doPunchOut();

  void openAppSettings();
}
