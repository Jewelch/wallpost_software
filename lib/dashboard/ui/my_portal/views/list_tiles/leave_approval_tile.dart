import 'package:flutter/material.dart';
import 'package:wallpost/approvals/entities/leave_approval.dart';

class LeaveApprovalTile extends StatelessWidget {
  final LeaveApproval _approval;

  LeaveApprovalTile(this._approval);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 200,
      child: Text(_approval.leaveTo),
    );
  }
}
