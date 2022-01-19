abstract class AttendanceView {
  void showLoader();

  void hideLoader();

  void showFailedToLoadAttendance(String title, String message);

  void showDisableButton();

  void showFailedToGetLocation(String message);

  void showLocationAddress(String address);

  void showPunchInButton();

  void showFailedToGetPunchInFromAppPermission(String message);

  void hideBreakButton();

  void showSecondTillPunchIn(String number);

}
