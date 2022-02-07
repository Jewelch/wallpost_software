import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';

abstract class AttendanceListView {
  void showLoader();

  void hideLoader();

  void showAttendanceList(List<AttendanceListItem> attendanceList);

  void showNoListMessage(String message);

  void showErrorMessage(String errorMessage);

  void goToAdjustmentScreen();
}
