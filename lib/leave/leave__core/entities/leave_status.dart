enum LeaveStatus {
  pendingApproval,
  approved,
  rejected,
  cancelled;

  static LeaveStatus? initFromInt(int status) {
    if (status == 0) {
      return LeaveStatus.pendingApproval;
    } else if (status == 1) {
      return LeaveStatus.approved;
    } else if (status == 2) {
      return LeaveStatus.rejected;
    } else {
      return LeaveStatus.cancelled;
    }
  }

  String toReadableString() {
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

  String toRawString() {
    if (this == LeaveStatus.pendingApproval) {
      return 'pending';
    } else if (this == LeaveStatus.approved) {
      return 'approved';
    } else if (this == LeaveStatus.rejected) {
      return 'rejected';
    } else {
      return 'cancelled';
    }
  }
}
