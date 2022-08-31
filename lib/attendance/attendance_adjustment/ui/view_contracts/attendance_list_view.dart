import 'package:wallpost/attendance/attendance_adjustment/entities/attendance_list_item.dart';

abstract class AttendanceListView {
  void showLoader();

  void onDidFailToLoadAttendanceList(String errorMessage);

  void showNoAttendanceMessage(String message);

  void onDidLoadAttendanceList();

  void goToAdjustmentScreen(AttendanceListItem attendanceList);
}
