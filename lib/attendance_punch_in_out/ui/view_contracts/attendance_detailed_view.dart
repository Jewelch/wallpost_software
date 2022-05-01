import '../../entities/attendance_location.dart';
import '../../entities/attendance_report.dart';

abstract class AttendanceDetailedView {
  void showPunchInTime(String time);

  void showPunchOutTime(String time);

  void showBreakButton();

  void hideBreakButton();

  void showResumeButton();

  void showLocationOnMap(AttendanceLocation attendanceLocation);

  void showAttendanceReport(AttendanceReport attendanceReport);
}
