enum LeaveListStatusFilter {
  all,
  pending,
  rejected,
  approved,
  cancelled;

  String toRawString() {
    switch (this) {
      case LeaveListStatusFilter.all:
        return "";
      case LeaveListStatusFilter.pending:
        return "pending";
      case LeaveListStatusFilter.rejected:
        return "rejected";
      case LeaveListStatusFilter.approved:
        return "approved";
      case LeaveListStatusFilter.cancelled:
        return "cancelled";
    }
  }

  String toReadableString() {
    switch (this) {
      case LeaveListStatusFilter.all:
        return "All";
      case LeaveListStatusFilter.pending:
        return "Pending";
      case LeaveListStatusFilter.rejected:
        return "Rejected";
      case LeaveListStatusFilter.approved:
        return "Approved";
      case LeaveListStatusFilter.cancelled:
        return "Cancelled";
    }
  }
}
