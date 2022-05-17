import 'dart:io';

import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ExpenseRequestForm implements JSONConvertible {
  String parentCategory;
  String category;
  String project = "";
  String date;
  String description;
  String quantity;
  String amount;
  File? file;
  String fileString = "";
  String total;

  ExpenseRequestForm({
    required this.parentCategory,
    required this.category,
    this.project = "",
    required this.date,
    required this.description,
    required this.quantity,
    required this.amount,
    required this.file,
    required this.total,
  });

  @override
  Map<String, dynamic> toJson() =>
      {
        "parentCategory": parentCategory,
        "category": category,
        "project": project,
        "expense_date": date,
        "description": description,
        "quantity": quantity,
        "rate": "",
        "amount": amount,
        "file": fileString,
        "total": total
      };
}