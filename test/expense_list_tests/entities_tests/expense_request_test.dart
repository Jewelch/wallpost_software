import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';

import '../_mocks/expense_requests_mock.dart';

main() {
  test("test initializing expense request successfully", () {
    var expenseCategory = ExpenseRequest.fromJson(expenseRequestsListResponse[0]);

    expect(expenseCategory.id, "368");
    expect(expenseCategory.totalAmount.toString(), "0.00");
    expect(expenseCategory.createdBy, "Pramod  R");
  });

  test("test initializing expense request with missing data throws a exception", () {
    try {
      var _ = ExpenseRequest.fromJson({});
    } catch (e) {
      expect(e is MappingException, true);
    }
  });
}
