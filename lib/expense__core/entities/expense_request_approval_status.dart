enum ExpenseRequestApprovalStatus {
  pending,
  rejected,
  approved;

  static ExpenseRequestApprovalStatus? initFromString(String string) {
    if (string == "pending") {
      return ExpenseRequestApprovalStatus.pending;
    } else if (string == "rejected") {
      return ExpenseRequestApprovalStatus.rejected;
    } else if (string == "approved") {
      return ExpenseRequestApprovalStatus.approved;
    }

    return null;
  }

  String toRawString() {
    switch (this) {
      case ExpenseRequestApprovalStatus.pending:
        return "pending";
      case ExpenseRequestApprovalStatus.rejected:
        return "rejected";
      case ExpenseRequestApprovalStatus.approved:
        return "approved";
    }
  }

  String toReadableString() {
    switch (this) {
      case ExpenseRequestApprovalStatus.pending:
        return "Pending";
      case ExpenseRequestApprovalStatus.rejected:
        return "Rejected";
      case ExpenseRequestApprovalStatus.approved:
        return "Approved";
    }
  }
}
