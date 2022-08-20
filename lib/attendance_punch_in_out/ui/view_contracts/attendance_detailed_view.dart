import '../../entities/attendance_location.dart';
import '../../entities/attendance_report.dart';

abstract class AttendanceDetailedView {
  void showAttendanceReportLoader();

  void showAttendanceReportErrorAndRetryView(String message);

  void showPunchInTime(String time);

  void showPunchOutTime(String time);

  void showBreakLoader();

  void hideBreakButton();

  void showBreakButton();

  void showResumeButton();

  void showLocationOnMap(AttendanceLocation attendanceLocation);

  void showAttendanceReport(AttendanceReport attendanceReport);
}
