enum ExpenseRequestsFilters { all, approved, rejected, pending }

extension ToString on ExpenseRequestsFilters {
  String toReadableString() {
    var string = "";
    switch (this) {
      case ExpenseRequestsFilters.all:
        string = "all";
        break;
      case ExpenseRequestsFilters.approved:
        string = "approved";
        break;
      case ExpenseRequestsFilters.rejected:
        string = "rejected";
        break;
      case ExpenseRequestsFilters.pending:
        string = "pending";
        break;
    }
    return string;
  }
}
