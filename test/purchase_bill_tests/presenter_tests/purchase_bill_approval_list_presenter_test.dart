
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/entities/purchase_bill_approval_list_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/services/purchase_bill_approval_list_provider.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/models/purchase_bill_approval_list_item_view_type.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/presenters/purchase_bill_approval_list_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/view_contracts/purchase_bill_approval_list_view.dart';

class MockPurchaseBillApprovalListView extends Mock implements PurchaseBillApprovalListView{}

class MockPurchaseBillApprovalListProvider extends Mock implements PurchaseBillApprovalListProvider{}

class MockPurchaseBillApprovalListItem extends Mock implements PurchaseBillApprovalBillItem{}

void main(){
  var view=MockPurchaseBillApprovalListView();
  var listProvider=MockPurchaseBillApprovalListProvider();
  late PurchaseBillApprovalListPresenter presenter;

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
    presenter = PurchaseBillApprovalListPresenter.initWith(view, listProvider);
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
        .thenAnswer((_) => Future.value([MockPurchaseBillApprovalListItem(), MockPurchaseBillApprovalListItem()]));

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
        .thenAnswer((_) => Future.value([MockPurchaseBillApprovalListItem(), MockPurchaseBillApprovalListItem()]));
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
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
    ]));
    await presenter.getNext();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
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
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
    ]));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "");
  });

  test('refreshing the list', () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
    ]));
    await presenter.getNext();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
      MockPurchaseBillApprovalListItem(),
    ]));
    await presenter.getNext();
    _clearAllInteractions();

    await presenter.refresh();

    //then
    verifyInOrder([
          () => listProvider.reset(),
          () => listProvider.isLoading,
          () => view.showLoader(),
          () => listProvider.getNext(),
          () => view.updateList(),
    ]);
    _verifyNoMoreInteractions();
    expect(presenter.getCountOfAllItems(), 1);
    expect(presenter.isSelectionInProgress, false);
  });

  //MARK: Tests for getting the list details

  test('get number of purchase bill list items when there are no items', () async {
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of purchase bill list items when there are no items and an error occurs', () async {
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
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
    ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), PurchaseBillApprovalListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
    ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), PurchaseBillApprovalListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
          () async {
        //given
        when(() => listProvider.isLoading).thenReturn(false);
        when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockPurchaseBillApprovalListItem(),
          MockPurchaseBillApprovalListItem(),
          MockPurchaseBillApprovalListItem(),
        ]));
        await presenter.getNext();
        when(() => listProvider.isLoading).thenReturn(false);
        when(() => listProvider.didReachListEnd).thenReturn(false);

        //when
        when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
        await presenter.getNext();

        //then
        expect(presenter.getNumberOfListItems(), 4);
        expect(presenter.getItemTypeAtIndex(0), PurchaseBillApprovalListItemViewType.ListItem);
        expect(presenter.getItemTypeAtIndex(1), PurchaseBillApprovalListItemViewType.ListItem);
        expect(presenter.getItemTypeAtIndex(2), PurchaseBillApprovalListItemViewType.ListItem);
        expect(presenter.getItemTypeAtIndex(3), PurchaseBillApprovalListItemViewType.ErrorMessage);
      });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
      MockPurchaseBillApprovalListItem(),
    ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(true);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), PurchaseBillApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), PurchaseBillApprovalListItemViewType.EmptySpace);
  });

  test('getting list item at index', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockPurchaseBillApprovalListItem();
    var approval2 = MockPurchaseBillApprovalListItem();
    var approval3 = MockPurchaseBillApprovalListItem();
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
    var approval1 = MockPurchaseBillApprovalListItem();
    var approval2 = MockPurchaseBillApprovalListItem();
    var approval3 = MockPurchaseBillApprovalListItem();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);
    _clearAllInteractions();

    //when
    presenter.showDetail(approval2);

    //then
    verifyInOrder([
          () => view.showExpenseDetail(approval2),
    ]);
    _verifyNoMoreInteractions();
  });
}