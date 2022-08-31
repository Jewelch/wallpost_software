import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/expense/expense_create/exceptions/invalid_expense_data_exception.dart';

import '../../../_shared/money/money.dart';
import 'expense_category.dart';

class ExpenseRequestForm implements JSONConvertible {
  final DateTime date;
  final ExpenseCategory mainCategory;
  final ExpenseCategory? subCategory;
  final ExpenseCategory? project;
  final Money rate;
  final int quantity;
  final String? description;
  String? _attachedFileName;

  ExpenseRequestForm({
    required this.date,
    required this.mainCategory,
    required this.subCategory,
    required this.project,
    required this.rate,
    required this.quantity,
    required this.description,
  }) {
    if (this.quantity <= 0) throw InvalidExpenseDataException("Quantity cannot be zero.");

    if (this.rate == Money.zero()) throw InvalidExpenseDataException("Rate cannot be zero.");
  }

  void setAttachedFileName(String? fileName) {
    _attachedFileName = fileName;
  }

  @override
  Map<String, dynamic> toJson() => {
        "parentCategory": "${mainCategory.id}",
        "category": subCategory != null ? "${subCategory!.id}" : null,
        "project": project != null ? "${project!.id}" : null,
        "expense_date": date.yyyyMMddString(),
        "description": description ?? "",
        "quantity": "$quantity",
        "rate": "${rate.toString()}",
        "amount": "${rate.multiply(quantity).toString()}",
        "file": _attachedFileName,
        "total": "${rate.multiply(quantity).toString()}",
      };
}
