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
}
