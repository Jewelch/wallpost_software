import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';

abstract class AttendanceView {
  void showLoader();

  void showAttendanceButtonLoader();

  void showButtonBreakLoader();

  void showErrorAlert(String title, String message);

  void showErrorAndRetryView(String message);

  void showRequestToTurnOnGpsView(String message);

  void showRequestToEnableLocationView(String message);

  void showCountDownView(int secondsTillPunchIn);

  void showPunchInButton();

  void showPunchOutButton();

  void showLocation(AttendanceLocation location, String address);

  void showAlertToMarkAttendanceWithInvalidLocation(bool isForPunchIn, String title, String message);
}
