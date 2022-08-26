import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/expense__core/entities/expense_request.dart';

Map<String, dynamic> expenseRequestJson = {
  "company_id": 23,
  "currency": "USD",
  "expense_id": 368,
  "expense_request_no": "NTC/ER/03/2022/00002",
  "total_amount": "0",
  "created_at": "2022-03-06 01:57:25",
  "created_by": 612,
  "created_by_name": "Pramod  R",
  "status": "approved",
  "description": "",
  "main_category": "main category"
};

class MockExpenseRequest extends ExpenseRequest {
  final String? mainCategoryToReturn;
  final String? projectToReturn;
  final String? subCategoryToReturn;
  final String? descriptionToReturn;

  MockExpenseRequest({
    required this.mainCategoryToReturn,
    required this.projectToReturn,
    required this.subCategoryToReturn,
    required this.descriptionToReturn,
  }) : super.fromJson(expenseRequestJson);

  @override
  String? get mainCategory => mainCategoryToReturn;

  @override
  String? get project => projectToReturn;

  @override
  String? get subCategory => subCategoryToReturn;

  @override
  String? get description => descriptionToReturn;
}

void main() {
  test("getting title", () {
    var expense = MockExpenseRequest(
      mainCategoryToReturn: "Main category",
      projectToReturn: "Some Project",
      subCategoryToReturn: "Sub category",
      descriptionToReturn: null,
    );
    expect(expense.getTitle(), "Main category: Some Project Sub category");

    expense = MockExpenseRequest(
      mainCategoryToReturn: "Main category",
      projectToReturn: null,
      subCategoryToReturn: null,
      descriptionToReturn: null,
    );
    expect(expense.getTitle(), "Main category");

    expense = MockExpenseRequest(
      mainCategoryToReturn: null,
      projectToReturn: "Some Project",
      subCategoryToReturn: null,
      descriptionToReturn: null,
    );
    expect(expense.getTitle(), "Some Project");

    expense = MockExpenseRequest(
      mainCategoryToReturn: null,
      projectToReturn: null,
      subCategoryToReturn: "Sub category",
      descriptionToReturn: null,
    );
    expect(expense.getTitle(), "Sub category");

    expense = MockExpenseRequest(
      mainCategoryToReturn: null,
      projectToReturn: null,
      subCategoryToReturn: null,
      descriptionToReturn: "Some description",
    );
    expect(expense.getTitle(), "Some description");

    expense = MockExpenseRequest(
      mainCategoryToReturn: null,
      projectToReturn: null,
      subCategoryToReturn: null,
      descriptionToReturn: null,
    );
    expect(expense.getTitle(), "");
  });
}
