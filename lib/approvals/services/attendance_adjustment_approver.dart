import 'package:wallpost/approvals/entities/attendance_adjustment_approval.dart';

class AttendanceAdjustmentApprover {

  Future<void> approve(AttendanceAdjustmentApproval approval) {
    return Future.value(null);
  }

  Future<void> reject(AttendanceAdjustmentApproval approval, String reason) {
    return Future.value(null);
  }

}