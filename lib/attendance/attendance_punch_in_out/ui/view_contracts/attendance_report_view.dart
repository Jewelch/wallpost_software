import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_report.dart';

abstract class AttendanceReportView {
  void showLoader();

  void showErrorAndRetryView(String message);

  void showAttendanceReport(AttendanceReport attendanceReport);
}
