enum ExpenseRequestStatusFilter { all, approved, rejected, pending }

extension ToString on ExpenseRequestStatusFilter {
  String toReadableString() {
    var string = "";
    switch (this) {
      case ExpenseRequestStatusFilter.all:
        string = "All";
        break;
      case ExpenseRequestStatusFilter.approved:
        string = "Approved";
        break;
      case ExpenseRequestStatusFilter.rejected:
        string = "Rejected";
        break;
      case ExpenseRequestStatusFilter.pending:
        string = "Pending";
        break;
    }
    return string;
  }

  String toRawString() {
    var string = "";
    switch (this) {
      case ExpenseRequestStatusFilter.all:
        string = "all";
        break;
      case ExpenseRequestStatusFilter.approved:
        string = "approved";
        break;
      case ExpenseRequestStatusFilter.rejected:
        string = "rejected";
        break;
      case ExpenseRequestStatusFilter.pending:
        string = "pending";
        break;
    }
    return string;
  }
}
