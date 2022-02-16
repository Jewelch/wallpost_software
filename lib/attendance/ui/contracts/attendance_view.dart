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


  //TODO: We don't need so many failure functions - use single function showErrorMessage(String title, String message)

  void showErrorMessage(String title, String message);

  //void showFailedToLoadAttendance(String title, String message);

  void showFailedToGetLocation(String title, String message);

  //void showFailedToGetPunchInFromAppPermission(String title, String message);

  //void showFailedToGetPunchInPermission(String title, String message);

  void showMessageToAllowPunchInFromAppPermission(String message);




  void showAlertToVerifyLocation(String message);


  //TODO: rename to requestToTurnOnDeviceLocation
  void showAlertToTurnOnDeviceLocation(String title, String message);

  //TODO: rename to requestLocationPermissions
  void showAlertToDeniedLocationPermission(String title, String message);


  //?
  void doPunchOut();


  // ?
  void openAppSettings();


  void showError(String title, String message);
}
