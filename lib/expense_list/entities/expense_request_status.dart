import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

enum ExpenseRequestStatus { approved, pending, rejected }

ExpenseRequestStatus fromStringToExpenseRequestStatus(String status) {
  if (status == 'approved') return ExpenseRequestStatus.approved;
  if (status == 'pending') return ExpenseRequestStatus.pending;
  if (status == 'rejected') return ExpenseRequestStatus.rejected;
  throw MappingException("Failed to cast ExpenseRequestStatus");
}

extension ToString on ExpenseRequestStatus {
  String toReadableString() {
    var string = "";
    switch (this) {
      case ExpenseRequestStatus.approved:
        string = "Approved";
        break;
      case ExpenseRequestStatus.rejected:
        string = "Rejected";
        break;
      case ExpenseRequestStatus.pending:
        string = "Pending";
        break;
    }
    return string;
  }
}

