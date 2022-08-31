import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/expense_approval_list/entities/expense_approval_list_item.dart';
import 'package:wallpost/expense_approval_list/services/expense_approval_list_provider.dart';
import 'package:wallpost/expense_approval_list/ui/models/expense_approval_list_item_view_type.dart';
import 'package:wallpost/expense_approval_list/ui/presenters/expense_approval_list_presenter.dart';
import 'package:wallpost/expense_approval_list/ui/view_contracts/expense_approval_list_view.dart';

class MockExpenseApprovalListView extends Mock implements ExpenseApprovalListView {}

class MockExpenseApprovalListProvider extends Mock implements ExpenseApprovalListProvider {}

class MockExpenseApprovalListItem extends Mock implements ExpenseApprovalListItem {}

void main() {
  var view = MockExpenseApprovalListView();
  var listProvider = MockExpenseApprovalListProvider();
  late ExpenseApprovalListPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(listProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(listProvider);
  }

  setUp(() {
    _clearAllInteractions();
    presenter = ExpenseApprovalListPresenter.initWith(view, listProvider);
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
    when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(),
      () => view.showErrorMessage(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the list when there are no items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([]));

    //when
    await presenter.getNext();

    //then
    expect(presenter.noItemsMessage, "There are no approvals to show.\n\nTap here to reload.");
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(),
      () => view.showNoItemsMessage(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the list with items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext())
        .thenAnswer((_) => Future.value([MockExpenseApprovalListItem(), MockExpenseApprovalListItem()]));

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to load the next list of items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext())
        .thenAnswer((_) => Future.value([MockExpenseApprovalListItem(), MockExpenseApprovalListItem()]));
    await presenter.getNext();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    //then
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.updateList(),
      () => listProvider.getNext(),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the next list of items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => listProvider.isLoading,
      () => view.updateList(),
      () => listProvider.getNext(),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('resets the error message before loading the next list of items', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "");
  });

  //MARK: Tests for getting the list details

  test('get number of leave list items when there are no items', () async {
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of leave list items when there are no items and an error occurs', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of list items when there are some items and the provider is loading', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseApprovalListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseApprovalListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //when
    when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseApprovalListItemViewType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
          MockExpenseApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(true);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseApprovalListItemViewType.EmptySpace);
  });

  test('getting list item at index', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockExpenseApprovalListItem();
    var approval2 = MockExpenseApprovalListItem();
    var approval3 = MockExpenseApprovalListItem();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval2);
    expect(presenter.getItemAtIndex(2), approval3);
  });

  //MARK: Tests to select items

  test('selecting an item', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockExpenseApprovalListItem();
    var approval2 = MockExpenseApprovalListItem();
    var approval3 = MockExpenseApprovalListItem();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);
    _clearAllInteractions();

    //when
    presenter.selectItem(approval2);

    //then
    verifyInOrder([
      () => view.showExpenseDetail(approval2),
    ]);
    _verifyNoMoreInteractions();
  });

  //MARK: Tests remove approved or rejected items

  test("successfully performing action on one item", () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockExpenseApprovalListItem();
    var approval2 = MockExpenseApprovalListItem();
    var approval3 = MockExpenseApprovalListItem();
    when(() => approval1.id).thenReturn("id1");
    when(() => approval2.id).thenReturn("id2");
    when(() => approval3.id).thenReturn("id3");
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    _clearAllInteractions();

    //when
    await presenter.onDidProcessApprovalOrRejection(true, "id2");

    //then
    expect(presenter.getNumberOfListItems(), 3);
    expect(presenter.getItemTypeAtIndex(0), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseApprovalListItemViewType.Loader);
    verifyInOrder([
      () => view.updateList(),
      () => listProvider.isLoading,
      () => listProvider.didReachListEnd,
    ]);
    _verifyNoMoreInteractions();
  });

  test("successfully performing action on all items", () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockExpenseApprovalListItem();
    var approval2 = MockExpenseApprovalListItem();
    var approval3 = MockExpenseApprovalListItem();
    when(() => approval1.id).thenReturn("id1");
    when(() => approval2.id).thenReturn("id2");
    when(() => approval3.id).thenReturn("id3");
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    await presenter.onDidProcessApprovalOrRejection(true, "id1");
    await presenter.onDidProcessApprovalOrRejection(true, "id2");
    _clearAllInteractions();

    //when
    await presenter.onDidProcessApprovalOrRejection(true, "id3");

    //then
    //then
    verifyInOrder([
      () => listProvider.reset(),
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(),
      () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test("does not reload data when processing approval or rejection with null or false", () async {
    presenter.onDidProcessApprovalOrRejection(null, "someExpenseId");
    _verifyNoMoreInteractions();

    presenter.onDidProcessApprovalOrRejection(false, "someExpenseId");
    _verifyNoMoreInteractions();
  });

  //MARK: Tests for getters

  test("getting title", () {
    var expense = MockExpenseApprovalListItem();
    when(() => expense.getTitle()).thenReturn("Some title");

    expect(presenter.getTitle(expense), "Some title");
  });

  test("get total amount", () {
    var expense = MockExpenseApprovalListItem();
    when(() => expense.totalAmount).thenReturn("USD 40.00");

    expect(presenter.getTotalAmount(expense), "USD 40.00");
  });

  test("get request number", () {
    var expense = MockExpenseApprovalListItem();
    when(() => expense.requestNumber).thenReturn("some request number");

    expect(presenter.getRequestNumber(expense), "some request number");
  });

  test("get request date", () {
    var expense = MockExpenseApprovalListItem();
    when(() => expense.requestDate).thenReturn(DateTime(2022, 8, 20));

    expect(presenter.getRequestDate(expense), "20 Aug 2022");
  });

  test("get requested by", () {
    var expense = MockExpenseApprovalListItem();
    when(() => expense.requestedBy).thenReturn("some name");

    expect(presenter.getRequestedBy(expense), "some name");
  });
}
