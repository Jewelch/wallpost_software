import 'package:flutter/material.dart';
import 'package:wallpost/approvals/entities/attendance_adjustment_approval.dart';

class AttendanceAdjustmentApprovalTile extends StatelessWidget {
  final AttendanceAdjustmentApproval _approval;

  AttendanceAdjustmentApprovalTile(this._approval);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      child: Text(_approval.attendanceId),
    );
  }
}
