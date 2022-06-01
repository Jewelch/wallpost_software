import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';

main() {
  test('set valid amount', () {
    ExpenseRequestModel model = ExpenseRequestModel();

    model.setAmount("100.11000000");

    expect(model.amount, "100.11");
  });

  test('set un valid amount', () {
    ExpenseRequestModel model = ExpenseRequestModel();

    model.setAmount("sadassadas");

    expect(model.amount, "0.00");
  });

  test('set valid quantity', () {
    ExpenseRequestModel model = ExpenseRequestModel();

    model.setQuantity("10");

    expect(model.amount, "100.11");
  });

  test('set un valid quantity', () {
    ExpenseRequestModel model = ExpenseRequestModel();

    model.setQuantity("sadassadas");

    expect(model.amount, "0.00");
  });
}
