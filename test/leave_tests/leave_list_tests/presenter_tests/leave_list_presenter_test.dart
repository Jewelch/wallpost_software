import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/leave/leave_list/entities/leave_list_item.dart';
import 'package:wallpost/leave/leave_list/entities/leave_list_status_filter.dart';
import 'package:wallpost/leave/leave_list/services/leave_list_provider.dart';
import 'package:wallpost/leave/leave_list/ui/models/leave_list_item_view_type.dart';
import 'package:wallpost/leave/leave_list/ui/presenters/leave_list_presenter.dart';
import 'package:wallpost/leave/leave_list/ui/view_contracts/leave_list_view.dart';

class MockLeaveListView extends Mock implements LeaveListView {}

class MockLeaveListProvider extends Mock implements LeaveListProvider {}

class MockLeaveListItem extends Mock implements LeaveListItem {}

main() {
  var view = MockLeaveListView();
  var listProvider = MockLeaveListProvider();
  late LeaveListPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(listProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(listProvider);
  }

  setUpAll(() {
    registerFallbackValue(MockLeaveListItem());
    registerFallbackValue(LeaveListStatusFilter.all);
  });

  setUp(() {
    _clearAllInteractions();
    presenter = LeaveListPresenter.initWith(view, listProvider);
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
        "There are no leave requests to show.\n\nTry changing the filters or tap here to reload.");
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
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([MockLeaveListItem(), MockLeaveListItem()]));

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
          MockLeaveListItem(),
          MockLeaveListItem(),
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
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
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

  //MARK: Tests for selecting an item

  test("selecting an item", () async {
    //given
    var leaves = [MockLeaveListItem(), MockLeaveListItem(), MockLeaveListItem()];
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value(leaves));
    _clearAllInteractions();
    await presenter.getNext();
    _clearAllInteractions();

    //when
    presenter.selectItem(leaves[1]);

    //then
    verifyInOrder([
      () => view.showLeaveDetail(leaves[1]),
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
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //when
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemViewType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveListItem(),
          MockLeaveListItem(),
          MockLeaveListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(true);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), LeaveListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), LeaveListItemViewType.EmptySpace);
  });

  test('getting list item at index', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockLeaveListItem();
    var approval2 = MockLeaveListItem();
    var approval3 = MockLeaveListItem();
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
    await presenter.selectStatusFilterAtIndex(2);

    //then
    verifyInOrder([
      () => listProvider.reset(),
      () => listProvider.isLoading,
      () => view.showLoader(),
      () => listProvider.getNext(LeaveListStatusFilter.rejected),
      () => view.showNoItemsMessage(),
    ]);
    _verifyNoMoreInteractions();
  });

  //MARK: Tests for getters

  test("getting title", () {
    var leave = MockLeaveListItem();
    when(() => leave.leaveType).thenReturn("Some Leave Type");

    expect(presenter.getTitle(leave), "Some Leave Type");
  });

  test("get total leave days", () {
    var leave = MockLeaveListItem();
    when(() => leave.totalLeaveDays).thenReturn(4);

    expect(presenter.getTotalLeaveDays(leave), "4 Days");
  });

  test("get start date", () {
    var leave = MockLeaveListItem();
    when(() => leave.startDate).thenReturn(DateTime(2022, 8, 20));

    expect(presenter.getStartDate(leave), "20 Aug 2022");
  });

  test("get end date", () {
    var leave = MockLeaveListItem();
    when(() => leave.endDate).thenReturn(DateTime(2022, 8, 23));

    expect(presenter.getEndDate(leave), "23 Aug 2022");
  });

  test('status is null when leave is approved', () async {
    var leave = MockLeaveListItem();
    when(() => leave.isApproved()).thenReturn(true);

    expect(presenter.getStatus(leave), null);
  });

  test('get status when status is pending and approver names are available', () async {
    var leave = MockLeaveListItem();
    when(() => leave.isApproved()).thenReturn(false);
    when(() => leave.isPendingApproval()).thenReturn(true);
    when(() => leave.pendingWithUsers).thenReturn("Some Username");
    when(() => leave.statusString).thenReturn("Pending");

    expect(presenter.getStatus(leave), "Pending with Some Username");
  });

  test('get status when status is pending and approver names are not available', () async {
    var leave = MockLeaveListItem();
    when(() => leave.isApproved()).thenReturn(false);
    when(() => leave.isPendingApproval()).thenReturn(true);
    when(() => leave.pendingWithUsers).thenReturn(null);
    when(() => leave.statusString).thenReturn("Pending");

    expect(presenter.getStatus(leave), "Pending");
  });

  test('get status for all other leave statuses', () async {
    var leave = MockLeaveListItem();
    when(() => leave.isApproved()).thenReturn(false);
    when(() => leave.isPendingApproval()).thenReturn(false);
    when(() => leave.statusString).thenReturn("Some Status");

    expect(presenter.getStatus(leave), "Some Status");
  });

  test('get status color', () async {
    var leave = MockLeaveListItem();

    when(() => leave.isPendingApproval()).thenReturn(true);
    expect(presenter.getStatusColor(leave), AppColors.yellow);

    when(() => leave.isPendingApproval()).thenReturn(false);
    expect(presenter.getStatusColor(leave), AppColors.red);
  });

  test("getting status filter list", () {
    var filters = LeaveListStatusFilter.values.map((status) => status.toReadableString()).toList();
    expect(presenter.getStatusFilterList(), filters);
  });

  test("getting selected filter", () async {
    //default filter
    expect(presenter.getSelectedStatusFilter(), LeaveListStatusFilter.all.toReadableString());

    //after selection
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext(any())).thenAnswer((_) => Future.value([MockLeaveListItem()]));
    await presenter.getNext();
    presenter.selectStatusFilterAtIndex(3);
    expect(presenter.getSelectedStatusFilter(), LeaveListStatusFilter.approved.toReadableString());
  });
}
