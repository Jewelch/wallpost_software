import '../../entities/attendance_location.dart';

abstract class AttendanceDetailedView {

  void showPunchInTime(String time);

  void showPunchOutTime(String time);

  void showBreakLoader();

  void hideBreakButton();

  void hideLoader();

  void showBreakButton();

  void showResumeButton();

  void showLocationOnMap(AttendanceLocation attendanceLocation);

}
