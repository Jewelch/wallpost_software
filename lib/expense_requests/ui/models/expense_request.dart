import 'package:wallpost/expense_requests/entities/expense_category.dart';

class ExpenseRequest {
  ExpenseRequest? selectedCategory;
  ExpenseRequest? selectedProject;
  DateTime date = DateTime.now();
  String? description;
  int quantity = 0;

  //if rate amount and total are strings, will have to do the numeric validation manually.
  String rate = "0.00"; // change to Money.


  // List<File> files;
  String filesString = "";




}

//TODO: Copy the money class from DinDone to this project. _shared/money/money.dart