enum AttendanceAdjustmentApprovalStatus {
  pending,
  approved,
  rejected;

  String stringValue() {
    if (this == AttendanceAdjustmentApprovalStatus.pending) {
      return 'pending';
    } else if (this == AttendanceAdjustmentApprovalStatus.approved) {
      return 'approved';
    } else {
      return 'rejected';
    }
  }

  String toReadableString() {
    if (this == AttendanceAdjustmentApprovalStatus.pending) {
      return 'Pending';
    } else if (this == AttendanceAdjustmentApprovalStatus.approved) {
      return 'Approved';
    } else {
      return 'Rejected';
    }
  }
}
