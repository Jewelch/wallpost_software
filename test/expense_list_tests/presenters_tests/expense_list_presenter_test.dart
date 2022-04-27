import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/expense_list/entities/expense_request.dart';
import 'package:wallpost/expense_list/services/expense_requests_provider.dart';
import 'package:wallpost/expense_list/ui/models/expense_list_item_type.dart';
import 'package:wallpost/expense_list/ui/presenters/expense_list_presenter.dart';
import 'package:wallpost/expense_list/ui/view_contracts/expense_list_view.dart';

class MockExpenseListView extends Mock implements ExpenseListView {}

class MockExpenseRequestsProvider extends Mock implements ExpenseRequestsProvider {}

class MockExpenseRequest extends Mock implements ExpenseRequest {}

main() {
  var view = MockExpenseListView();
  var provider = MockExpenseRequestsProvider();
  late ExpenseListPresenter presenter;

  // MARK: Helper functions

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(provider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(provider);
  }

  setUp(() {
    _clearAllInteractions();
    presenter = ExpenseListPresenter.initWith(view, provider);
  });

  // MARK: test functions

  test('fail to load expense requests', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));

    await presenter.getNextExpenses();

    expect(presenter.errorMessage,
        "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => view.showLoader(),
      () => provider.getNext(),
      () => view.showErrorMessage(
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the expense requests list when there are no items', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([]));

    await presenter.getNextExpenses();

    verifyInOrder([
      () => view.showLoader(),
      () => provider.getNext(),
      () => view.showErrorMessage("There are no expense requests to show.\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the expenses list with items', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));

    await presenter.getNextExpenses();

    verifyInOrder([
      () => view.showLoader(),
      () => provider.getNext(),
      () => view.updateExpenseList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to load the next list of items', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNextExpenses();
    when(() => provider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    _clearAllInteractions();

    await presenter.getNextExpenses();

    expect(presenter.errorMessage,
        "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => view.updateExpenseList(),
      () => provider.getNext(),
      () => view.updateExpenseList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the next list of items', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNextExpenses();
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    _clearAllInteractions();

    await presenter.getNextExpenses();

    expect(presenter.errorMessage, "");
    verifyInOrder([
      () => view.updateExpenseList(),
      () => provider.getNext(),
      () => view.updateExpenseList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('resets the error message before loading the next list of items', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNextExpenses();
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    _clearAllInteractions();

    await presenter.getNextExpenses();

    expect(presenter.errorMessage, "");
  });

  //MARK: Tests getting the list details

  test('get number of expense list items when there are no items', () async {
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of expense list items when there are no items and an error occurs', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));

    await presenter.getNextExpenses();

    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of list items when there are some items and the provider is loading', () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNextExpenses();
    when(() => provider.didReachListEnd).thenReturn(false);
    when(() => provider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items',
      () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNextExpenses();
    when(() => provider.didReachListEnd).thenReturn(false);
    when(() => provider.isLoading).thenReturn(true);

    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.Loader);
  });

  test(
      'get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNextExpenses();
    when(() => provider.didReachListEnd).thenReturn(false);
    when(() => provider.isLoading).thenReturn(false);

    when(() => provider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNextExpenses();

    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items',
      () async {
    when(() => provider.getNext()).thenAnswer((_) => Future.value([
          MockExpenseRequest(),
          MockExpenseRequest(),
          MockExpenseRequest(),
        ]));
    await presenter.getNextExpenses();
    when(() => provider.didReachListEnd).thenReturn(true);
    when(() => provider.isLoading).thenReturn(false);

    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(1), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(2), ExpenseListItemType.ExpenseListItem);
    expect(presenter.getItemTypeAtIndex(3), ExpenseListItemType.EmptySpace);
  });
}
