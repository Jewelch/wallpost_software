import 'package:flutter/material.dart';

import '../view_contracts/attendance_view.dart';

class AttendanceButton extends StatelessWidget implements AttendanceView {
  const AttendanceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Punch In"),
    );
  }

  @override
  void doPunchOut() {
    // TODO: implement doPunchOut
  }

  @override
  void hideBreakButton() {
    // TODO: implement hideBreakButton
  }

  @override
  void hideLoader() {
    // TODO: implement hideLoader
  }

  @override
  void openAppSettings() {
    // TODO: implement openAppSettings
  }

  @override
  void showAlertToDeniedLocationPermission(String title, String message) {
    // TODO: implement showAlertToDeniedLocationPermission
  }

  @override
  void showAlertToTurnOnDeviceLocation(String title, String message) {
    // TODO: implement showAlertToTurnOnDeviceLocation
  }

  @override
  void showAlertToVerifyLocation(String message) {
    // TODO: implement showAlertToVerifyLocation
  }

  @override
  void showBreakButton() {
    // TODO: implement showBreakButton
  }

  @override
  void showDisabledButton() {
    // TODO: implement showDisabledButton
  }

  @override
  void showError(String title, String message) {
    // TODO: implement showError
  }

  @override
  void showErrorMessage(String title, String message) {
    // TODO: implement showErrorMessage
  }

  @override
  void showFailedToGetLocation(String title, String message) {
    // TODO: implement showFailedToGetLocation
  }

  @override
  void showLoader() {
    // TODO: implement showLoader
  }

  @override
  void showLocationAddress(String address) {
    // TODO: implement showLocationAddress
  }

  @override
  void showMessageToAllowPunchInFromAppPermission(String message) {
    // TODO: implement showMessageToAllowPunchInFromAppPermission
  }

  @override
  void showPunchInButton() {
    // TODO: implement showPunchInButton
  }

  @override
  void showPunchInTime(String time) {
    // TODO: implement showPunchInTime
  }

  @override
  void showPunchOutButton() {
    // TODO: implement showPunchOutButton
  }

  @override
  void showPunchOutTime(String time) {
    // TODO: implement showPunchOutTime
  }

  @override
  void showResumeButton() {
    // TODO: implement showResumeButton
  }

  @override
  void showTimeTillPunchIn(num seconds) {
    // TODO: implement showTimeTillPunchIn
  }
  
  
  
  
}
