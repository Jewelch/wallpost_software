import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';

import '../_mocks/expense_categories_mock.dart';

main() {
  test("test initializing expense category successfully", () {
    var expenseCategory = ExpenseCategory.fromJson(validExpenseCategoryMap);

    expect(expenseCategory.id, "1");
    expect(expenseCategory.name, "Camp Expense");
    expect(expenseCategory.subCategories.length, 1);
  });

  test("test initializing expense category with missing data throws a exception", () {
    try {
      var _ = ExpenseCategory.fromJson(unValidExpenseCategoryMap);
    } catch (e) {
      expect(e is MappingException, true);
    }
  });
}
