import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/expense/expense__core/entities/expense_request.dart';
import 'package:wallpost/expense/expense__core/entities/expense_request_approval_status.dart';
import 'package:wallpost/expense/expense_list/entities/expense_request_approval_status_filter.dart';
import 'package:wallpost/expense/expense_list/services/expense_list_provider.dart';
import 'package:wallpost/expense/expense_list/ui/models/expense_list_item_type.dart';
import 'package:wallpost/expense/expense_list/ui/presenters/expense_list_presenter.dart';
import 'package:wallpost/expense/expense_list/ui/view_contracts/expense_list_view.dart';

class MockExpenseListView extends Mock implements ExpenseListView {}

class MockExpenseListProvider extends Mock implements ExpenseListProvider {}

class MockExpenseRequest extends Mock implements ExpenseRequest {}

main() {
  var view = MockExpenseListView();
  var listProvider = MockExpenseListProvider();
  late ExpenseListPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(listProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(listProvider);
  }

  setUpAll(() {
    registerFallbackValue(MockExpenseRequest());
    registerFallbackValue(ExpenseRequestApprovalStatusFilter.all);
  });

  setUp(() {
    _clearAllInteractions();
    presenter = ExpenseListPresenter.initWith(view, listProvider);
  });

  //MARK: Tests for loading the list

  test('does nothing when the provider is loading', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(true);

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => listProvider.isLoading,
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to load list', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(any()),
      () => view.showErrorMessage(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the list when there are no items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([]));

    //when
    await presenter.getNext();

    //then
    expect(presenter.noItemsMessage,
        "There are no expense requests to show.\n\nTry changing the filters or tap here to reload.");
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(any()),
      () => view.showNoItemsMessage(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the list with items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any()))
        .thenAnswer((_) => Future.value([MockExpenseRequest(), MockExpenseRequest()]));

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(any()),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to load the next list of items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNext();
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    //then
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.updateList(),
      () => listProvider.getNext(any()),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the next list of items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNext();
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.updateList(),
      () => listProvider.getNext(any()),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('resets the error message before loading the next list of items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "");
  });

  //MARK: Tests for selecting an item

  test("selecting an item", () async {
    //given
    var expenseRequests = [MockExpenseRequest(), MockExpenseRequest(), MockExpenseRequest()];
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value(expenseRequests));
    _clearAllInteractions();
    await presenter.getNext();
    _clearAllInteractions();

    //when
    presenter.selectItem(expenseRequests[1]);

    //then
    verifyInOrder([
      () => view.showExpenseDetail(expenseRequests[1]),
    ]);
  });

  //MARK: Tests for getting the list details

  test('get number of leave list items when there are no items', () async {
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of leave list items when there are no items and an error occurs', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of list items when there are some items and the provider is loading', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //when
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(true);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.EmptySpace);
  });

  test('getting list item at index', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockExpenseRequest();
    var approval2 = MockExpenseRequest();
    var approval3 = MockExpenseRequest();
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval2);
    expect(presenter.getItemAtIndex(2), approval3);
  });

  //MARK: Tests for filters

  test('applying approval status filter', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([]));

    //when
    await presenter.selectApprovalStatusFilterAtIndex(2);

    //then
    verifyInOrder([
      () => listProvider.reset(),
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(ExpenseRequestApprovalStatusFilter.rejected),
      () => view.showNoItemsMessage(),
    ]);
    _verifyNoMoreInteractions();
  });

  //MARK: Tests for getters

  test("getting title", () {
    var expense = MockExpenseRequest();
    when(() => expense.getTitle()).thenReturn("Some title");

    expect(presenter.getTitle(expense), "Some title");
  });

  test("get total amount", () {
    var expense = MockExpenseRequest();
    when(() => expense.totalAmount).thenReturn("USD 40.00");

    expect(presenter.getTotalAmount(expense), "USD 40.00");
  });

  test("get request number", () {
    var expense = MockExpenseRequest();
    when(() => expense.requestNumber).thenReturn("some request number");

    expect(presenter.getRequestNumber(expense), "some request number");
  });

  test("get request date", () {
    var expense = MockExpenseRequest();
    when(() => expense.requestDate).thenReturn(DateTime(2022, 8, 20));

    expect(presenter.getRequestDate(expense), "20 Aug 2022");
  });

  test("get requested by", () {
    var expense = MockExpenseRequest();
    when(() => expense.requestedBy).thenReturn("some name");

    expect(presenter.getRequestedBy(expense), "some name");
  });

  test("get status", () {
    var expense = MockExpenseRequest();

    //when status message is null
    when(() => expense.statusMessage).thenReturn(null);
    expect(presenter.getStatus(expense), "");

    //when status message is not null
    when(() => expense.statusMessage).thenReturn("some status message");
    expect(presenter.getStatus(expense), "some status message");
  });

  test("get status color", () {
    var expense = MockExpenseRequest();

    //pending
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.pending);
    expect(presenter.getStatusColor(expense), AppColors.yellow);

    //rejected
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.rejected);
    expect(presenter.getStatusColor(expense), AppColors.red);

    //approved
    when(() => expense.approvalStatus).thenReturn(ExpenseRequestApprovalStatus.approved);
    expect(presenter.getStatusColor(expense), AppColors.green);
  });

  test("getting status filter list", () {
    var filters = ExpenseRequestApprovalStatusFilter.values.map((status) => status.toReadableString()).toList();
    expect(presenter.getStatusFilterList(), filters);
  });

  test("getting selected filter", () async {
    //default filter
    expect(presenter.getSelectedStatusFilter(), ExpenseRequestApprovalStatusFilter.all.toReadableString());

    //after selection
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([MockExpenseRequest()]));
    await presenter.getNext();
    presenter.selectApprovalStatusFilterAtIndex(3);
    expect(presenter.getSelectedStatusFilter(), ExpenseRequestApprovalStatusFilter.approved.toReadableString());
  });
}
