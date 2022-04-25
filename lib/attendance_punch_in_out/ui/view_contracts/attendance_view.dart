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

  void requestToLocationPermissions(String title, String message);

  // The user opted to never again see the permission request dialog for this
  // app. The only way to change the permission's status now is to let the
  // user manually enable it in the system settings.
  void openAppSettings();

  void showErrorMessage(String title, String message);

  void showError(String title, String message);
}
