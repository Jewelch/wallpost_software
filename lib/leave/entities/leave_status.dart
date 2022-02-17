import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

enum LeaveStatus {
  pendingApproval,
  approved,
  rejected,
  cancelled,
}

extension LeaveStatusExtension on LeaveStatus {
  String stringValue() {
    if (this == LeaveStatus.pendingApproval) {
      return 'Pending Approval';
    } else if (this == LeaveStatus.approved) {
      return 'Approved';
    } else if (this == LeaveStatus.rejected) {
      return 'Rejected';
    } else {
      return 'Cancelled';
    }
  }

  Color colorValue() {
    if (this == LeaveStatus.pendingApproval) {
      return AppColors.pendingApprovalColor;
    } else if (this == LeaveStatus.approved) {
      return AppColors.approvedColor;
    } else if (this == LeaveStatus.rejected) {
      return AppColors.rejectedColor;
    } else {
      return AppColors.cancelledColor;
    }
  }
}
