enum ExpenseRequestApprovalStatusFilter {
  all,
  pending,
  rejected,
  approved;

  String toRawString() {
    switch (this) {
      case ExpenseRequestApprovalStatusFilter.all:
        return "";
      case ExpenseRequestApprovalStatusFilter.pending:
        return "pending";
      case ExpenseRequestApprovalStatusFilter.rejected:
        return "rejected";
      case ExpenseRequestApprovalStatusFilter.approved:
        return "approved";
    }
  }

  String toReadableString() {
    switch (this) {
      case ExpenseRequestApprovalStatusFilter.all:
        return "All";
      case ExpenseRequestApprovalStatusFilter.pending:
        return "Pending";
      case ExpenseRequestApprovalStatusFilter.rejected:
        return "Rejected";
      case ExpenseRequestApprovalStatusFilter.approved:
        return "Approved";
    }
  }
}
