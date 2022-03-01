import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense_requests/ui/presenters/per_expense_request_presenter.dart';

import '../_mocks/expense_request_mocks.dart';

main() {
  var mockExpenseCategory = MockExpenseCategory();
  var view = MockPerExpenseRequestView();
  late PerExpenseRequestPresenter presenter;

  setUp(() {
    when(() => mockExpenseCategory.id).thenReturn("1");
    presenter = PerExpenseRequestPresenter(view);
  });

  test("getting expense request successfully", () {
    presenter.parentCategory = mockExpenseCategory;
    presenter.category = mockExpenseCategory;
    presenter.setDate(DateTime.now());

    var expenseRequest = presenter.getExpenseRequest();

    expect(expenseRequest != null, true);
    verifyNoMoreInteractions(view);
  });

  test("notify view when all required data were missing", () {
    var expenseRequest = presenter.getExpenseRequest();

    expect(expenseRequest == null, true);
    verifyInOrder([
      () => view.notifyMissingParentCategory("Missing Category Value"),
    ]);
    verifyNoMoreInteractions(view);
  });

  test("notify view when parentCategory data is missing", () {
    presenter.category = mockExpenseCategory;
    presenter.setDate(DateTime.now());

    var expenseRequest = presenter.getExpenseRequest();

    expect(expenseRequest == null, true);
    verifyInOrder([
      () => view.notifyMissingParentCategory("Missing Category Value"),
    ]);
    verifyNoMoreInteractions(view);
  });

  test("notify view when category data is missing", () {
    presenter.parentCategory = mockExpenseCategory;
    presenter.setDate(DateTime.now());

    var expenseRequest = presenter.getExpenseRequest();

    expect(expenseRequest == null, true);
    verifyInOrder([
      () => view.notifyMissingChildCategory("Missing SubCategory Value"),
    ]);
    verifyNoMoreInteractions(view);
  });

  test("notify view when date data is missing", () {
    presenter.parentCategory = mockExpenseCategory;
    presenter.category = mockExpenseCategory;

    var expenseRequest = presenter.getExpenseRequest();

    expect(expenseRequest == null, true);
    verifyInOrder([
      () => view.notifyMissingDate("Missing Date Value"),
    ]);
    verifyNoMoreInteractions(view);
  });
}
