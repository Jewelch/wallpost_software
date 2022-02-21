import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/services/leave_list_provider.dart';
import 'package:wallpost/leave/ui/models/leave_list_item_type.dart';
import 'package:wallpost/leave/ui/presenters/leave_list_presenter.dart';
import 'package:wallpost/leave/ui/view_contracts/leave_list_view.dart';

class MockLeaveListView extends Mock implements LeaveListView {}

class MockLeaveListProvider extends Mock implements LeaveListProvider {}

class MockLeaveListItem extends Mock implements LeaveListItem {}

void main() {
  var view = MockLeaveListView();
  var leaveListProvider = MockLeaveListProvider();
  late LeaveListPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(leaveListProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(leaveListProvider);
  }

  setUpAll(() {
    registerFallbackValue(LeaveListFilters());
  });

  setUp(() {
    _clearAllInteractions();
    presenter = LeaveListPresenter.initWith(view, leaveListProvider);
  });

  //MARK: Tests for loading the list

  test('failure to load leave list', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.getNext();

    //then
    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    verifyInOrder([
      () => view.showLoader(),
      () => leaveListProvider.getNext(any()),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the leave list when there are no items', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([]));

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => leaveListProvider.getNext(any()),
      () => view.showErrorMessage("There are no leaves to show.\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the leave list with items', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => leaveListProvider.getNext(any()),
      () => view.updateLeaveList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to load the next list of items', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    expect(presenter.errorMessage, "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
    //then
    verifyInOrder([
      () => view.updateLeaveList(),
      () => leaveListProvider.getNext(any()),
      () => view.updateLeaveList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the next list of items', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    _clearAllInteractions();

    //when
    await presenter.getNext();

    //then
    verifyInOrder([
          () => view.updateLeaveList(),
      () => leaveListProvider.getNext(any()),
      () => view.updateLeaveList(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('resets the error message before loading the next list of items', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
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
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 0);
  });

  test('get number of list items when there are some items and the provider is loading', () async {
    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(false);
    when(() => leaveListProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(false);
    when(() => leaveListProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(false);
    when(() => leaveListProvider.isLoading).thenReturn(false);

    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(true);
    when(() => leaveListProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemType.LeaveListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemType.EmptySpace);
  });
}
