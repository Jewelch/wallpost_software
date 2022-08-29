import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/expense__core/entities/expense_request.dart';

void main() {
  ExpenseRequest initExpenseRequest({
    required String? mainCategory,
    required String? project,
    required String? subCategory,
    required String? description,
  }) {
    return ExpenseRequest.fromJson({
      "main_category": mainCategory,
      "project": project,
      "sub_category": subCategory,
      "description": description,
      "company_id": 23,
      "currency": "USD",
      "expense_id": 368,
      "expense_request_no": "NTC/ER/03/2022/00002",
      "total_amount": "0",
      "created_at": "2022-03-06 01:57:25",
      "created_by": 612,
      "created_by_name": "Pramod  R",
      "status": "approved",
    });
  }

  test("getting title", () {
    var expense = initExpenseRequest(
      mainCategory: "Main category",
      project: "Some Project",
      subCategory: "Sub category",
      description: null,
    );
    expect(expense.getTitle(), "Main category: Some Project Sub category");

    expense = initExpenseRequest(
      mainCategory: "Main category",
      project: null,
      subCategory: null,
      description: null,
    );
    expect(expense.getTitle(), "Main category");

    expense = initExpenseRequest(
      mainCategory: null,
      project: "Some Project",
      subCategory: null,
      description: null,
    );
    expect(expense.getTitle(), "Some Project");

    expense = initExpenseRequest(
      mainCategory: null,
      project: null,
      subCategory: "Sub category",
      description: null,
    );
    expect(expense.getTitle(), "Sub category");

    expense = initExpenseRequest(
      mainCategory: null,
      project: null,
      subCategory: null,
      description: "Some description",
    );
    expect(expense.getTitle(), "Some description");

    expense = initExpenseRequest(
      mainCategory: null,
      project: null,
      subCategory: null,
      description: null,
    );
    expect(expense.getTitle(), "");
  });
}
