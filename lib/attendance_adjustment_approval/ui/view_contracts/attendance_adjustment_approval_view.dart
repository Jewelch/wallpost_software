import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';

abstract class AttendanceAdjustmentApprovalView {
  void onDidFailToApproveOrReject(String title, String message);

  void onDidApproveOrRejectSuccessfully(AttendanceAdjustmentApproval approval);
}
