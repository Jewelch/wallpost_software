import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense_requests/exeptions/failed_to_save_requet.dart';
import 'package:wallpost/expense_requests/services/expense_request_executor.dart';
import 'package:wallpost/expense_requests/ui/presenters/expense_request_presenter.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';

import '../_mocks/expense_request_mocks.dart';

class MockExpenseView extends Mock implements ExpenseRequestsView {}

class MockExecutor extends Mock implements ExpenseRequestExecutor {}

main() {
  var view = MockExpenseView();
  var executor = MockExecutor();
  var presenter = ExpenseRequestPresenter.initWith(view, executor);

  setUpAll(() {
    registerFallbackValue(getExpenseRequestForm());
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(executor);
  }

  test("notify view to reset all errors in the start of sending expense request", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getExpenseRequest();
    expenseRequest.selectedMainCategory = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
    ]);
    clearInteractions(view);
    clearInteractions(executor);
  });

  test(
      "notify missing main category when try to send expense request with missed main category data",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getExpenseRequest();
    expenseRequest.selectedMainCategory = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
      view.notifyMissingMainCategory,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("notify missing sub category when try to send expense request with missed sub category data",
      () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getExpenseRequest();
    expenseRequest.selectedSubCategory = null;

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
      view.notifyMissingSubCategory,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("send expense request successfully", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(true));
    var expenseRequest = getExpenseRequest();

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
      view.showLoader,
      () => executor.execute(any()),
      view.hideLoader,
      view.onSendRequestsSuccessfully,
    ]);
  });

  test("send expense request fails and throw exception", () async {
    when(() => executor.execute(any())).thenAnswer((invocation) => throw FailedToSaveRequest());
    var expenseRequest = getExpenseRequest();

    await presenter.sendExpenseRequest(expenseRequest);

    verifyInOrder([
      view.resetErrors,
      view.showLoader,
      () => executor.execute(any()),
      view.hideLoader,
      () => view.showErrorMessage(FailedToSaveRequest.USER_READABLE_MESSAGE),
    ]);
  });
}
