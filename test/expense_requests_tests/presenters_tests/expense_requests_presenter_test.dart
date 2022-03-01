import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/network_failure_exception.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/exeptions/missing_expense_request_data.dart';
import 'package:wallpost/expense_requests/ui/presenters/expense_requests_presenter.dart';
import 'package:wallpost/expense_requests/services/expense_request_executor.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';

import '../_mocks/expense_request_mocks.dart';

class MockExpenseRequestsView extends Mock implements ExpenseRequestsView {}

class MockExpenseRequestExecutor extends Mock implements ExpenseRequestExecutor {}

main() {
  // setup per expense requests
  var request = MockExpenseRequest();
  var perRequestView1 = MockPerExpenseRequestView();
  var perRequestView2 = MockPerExpenseRequestView();
  var perRequestView3 = MockPerExpenseRequestView();
  List<MockPerExpenseRequestView> requestsViews = [];

  // setup dependencies
  var view = MockExpenseRequestsView();
  var executor = MockExpenseRequestExecutor();
  late ExpenseRequestsPresenter presenter;

  setUp(() {
    when(perRequestView1.getExpenseRequest).thenReturn(request);
    when(perRequestView2.getExpenseRequest).thenReturn(request);
    when(perRequestView3.getExpenseRequest).thenReturn(request);
    when(() => executor.execute(any())).thenAnswer((invocation) => Future.value(null));
    presenter = ExpenseRequestsPresenter.initWith(view, executor);
  });

  _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(perRequestView1);
    verifyNoMoreInteractions(perRequestView2);
    verifyNoMoreInteractions(perRequestView3);
    verifyNoMoreInteractions(request);
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(executor);
  }

  test("test send multiple expense requests successfully", () async {
    requestsViews = [perRequestView1, perRequestView2, perRequestView3];

    await presenter.sendExpenseRequests(requestsViews);

    verifyInOrder([
      view.showLoader,
      perRequestView1.getExpenseRequest,
      perRequestView2.getExpenseRequest,
      perRequestView3.getExpenseRequest,
      () => executor.execute(any()),
      view.hideLoader,
      view.onSendRequestsSuccessfully,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "test send multiple expense requests throw exception when one of per request view return null",
      () {
    when(perRequestView2.getExpenseRequest).thenReturn(null);

    requestsViews = [perRequestView1, perRequestView2, perRequestView3];

    presenter.sendExpenseRequests(requestsViews);

    verifyInOrder([
      view.showLoader,
      perRequestView1.getExpenseRequest,
      perRequestView2.getExpenseRequest,
      view.hideLoader,
      () => view.showErrorMessage(MissingExpenseRequestData.USER_READABLE_MESSAGE)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("test send multiple expense requests throw exception when field to send them to server", () {
    when(() => executor.execute(any())).thenAnswer((invocation) => throw NetworkFailureException());
    requestsViews = [perRequestView1, perRequestView2, perRequestView3];

    presenter.sendExpenseRequests(requestsViews);

    verifyInOrder([
      view.showLoader,
      perRequestView1.getExpenseRequest,
      perRequestView2.getExpenseRequest,
      perRequestView3.getExpenseRequest,
      () => executor.execute(any()),
      view.hideLoader,
      () => view.showErrorMessage("Please check your network connection and try again.")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
