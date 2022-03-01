import 'dart:io';

import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

class ExpenseRequestForm implements JSONConvertible {
  String parentCategory;
  String category;
  String project = "";
  String date;
  String description;
  String quantity;
  String rate;
  String amount;
  List<File> files;
  String filesString = "";
  String total;

  ExpenseRequestForm({
    required this.parentCategory,
    required this.category,
    this.project = "",
    required this.date,
    required this.description,
    required this.quantity,
    required this.rate,
    required this.amount,
    required this.files,
    required this.total,
  });

  //TODO: Ask Niyas for create expense request sample request payload
  @override
  Map<String, dynamic> toJson() => {
        "id": 0,
        "parentCategory": parentCategory,
        "category": category,
        "project": project,
        "expense_request_id": 0,
        "expense_date": date,
        "description": description,
        "quantity": quantity,
        "rate": rate,
        "amount": amount,
        "file": filesString,
        "total": total
      };
}
