abstract class AttendanceView {
  void showLoader();

  void showErrorMessage(String title, String message);

  void showErrorAndRetryView(String message);

  void showRequestToTurnOnGpsView(String message);

  void showRequestToEnableLocationView(String message);

  void showCountDownView(int secondsTillPunchIn);

  void showPunchInButton();

  void showPunchOutButton();

  void showAddress(String address);

  void showAlertToMarkAttendanceWithInvalidLocation(bool isForPunchIn, String title, String message);

  void doRefresh();

  void showAttendanceButtonLoader();
}
