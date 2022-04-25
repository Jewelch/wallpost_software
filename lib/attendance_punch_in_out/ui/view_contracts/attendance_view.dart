import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_report.dart';

abstract class AttendanceView {
  void showLoader();

  void hideLoader();

  void showPunchInButton();

  void showPunchOutButton();

  void showDisabledButton();

  void hideBreakButton();

  void showBreakButton();

  void showResumeButton();

  void showPunchInTime(String time);

  void showPunchOutTime(String time);

  void showTimeTillPunchIn(num seconds);

  void showLocationPositions(AttendanceLocation attendanceLocation);

  void showLocationAddress(String address);

  void showAttendanceReport(AttendanceReport attendanceReport);

  void doRefresh();

  void showAlertToInvalidLocation(
      bool isForPunchIn, String title, String message);

  void requestToTurnOnDeviceLocation(String title, String message);

  void requestToLocationPermissions(bool isDenied,String title, String message);

  void showErrorMessage(String title, String message);

  void showError(String title, String message);
}
