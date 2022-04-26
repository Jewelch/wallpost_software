import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_report.dart';

abstract class AttendanceView {
  void showLoader();

  // void hideLoader();

  void showErrorAndRetryView(String title, String message);

  void showCountDownView(int secondsTillPunchIn);





  void showPunchInButton();

  void showPunchOutButton();


  void hideBreakButton();

  void showBreakButton();

  void showResumeButton();



  void showPunchInTime(String time);

  void showPunchOutTime(String time);


  void showLocationPositions(AttendanceLocation attendanceLocation);

void showAddress(String address);




  void showAttendanceReport(AttendanceReport attendanceReport);

  //TODO ?
  void doRefresh();

  void showAlertToInvalidLocation(
      bool isForPunchIn, String title, String message);



  void showRequestToTurnOnGpsView(String message);

  void showRequestToEnableLocationView(String message);


}
