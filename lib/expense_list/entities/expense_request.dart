import 'dart:io';

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class ExpenseRequest
    // extends JSONInitializable
{
  late final String id;
  // String parentCategory;
  // String category;
  // String project = "";
  // String date;
  // String description;
  // String quantity;
  // String rate;
  // String amount;
  // File? file;
  // String fileString = "";
  // String total;

  ExpenseRequest.fromJson(Map<String, dynamic> jsonMap)
      // : super.fromJson(jsonMap)
  {
    var sift = Sift();
    id = sift.readNumberFromMap(jsonMap, 'id').toString();
  }


  // @override
  // Map<String, dynamic> toJson() => {
  //       "parentCategory": parentCategory,
  //       "category": category,
  //       "project": project,
  //       "expense_date": date,
  //       "description": description,
  //       "quantity": quantity,
  //       "rate": rate,
  //       "amount": amount,
  //       "file": fileString,
  //       "total": total
  //     };
}
