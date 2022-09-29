import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance/attendance__core/utils/attendance_status_color.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/entities/attendance_adjustment_approval_list_item.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/services/attendance_adjustment_approval_list_provider.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/models/attendance_adjustment_approval_list_item_view_type.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/presenters/attendance_adjustment_approval_list_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/view_contracts/attendance_adjustment_approval_list_view.dart';

class MockAttendanceAdjustmentApprovalListView extends Mock implements AttendanceAdjustmentApprovalListView {}

class MockAttendanceAdjustmentApprovalListProvider extends Mock implements AttendanceAdjustmentApprovalListProvider {}

class MockAttendanceAdjustmentApprovalListItem extends Mock implements AttendanceAdjustmentApprovalListItem {}

void main() {
  var view = MockAttendanceAdjustmentApprovalListView();
  var listProvider = MockAttendanceAdjustmentApprovalListProvider();
  late AttendanceAdjustmentApprovalListPresenter presenter;

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
    presenter = AttendanceAdjustmentApprovalListPresenter.initWith(view, listProvider);
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
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));

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
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));
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
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
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
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
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
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), AttendanceAdjustmentApprovalListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), AttendanceAdjustmentApprovalListItemViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.didReachListEnd).thenReturn(false);

    //when
    when(() => listProvider.getNext()).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), AttendanceAdjustmentApprovalListItemViewType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
          MockAttendanceAdjustmentApprovalListItem(),
        ]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(true);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(3), AttendanceAdjustmentApprovalListItemViewType.EmptySpace);
  });

  test('getting list item at index', () async {
    //when
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockAttendanceAdjustmentApprovalListItem();
    var approval2 = MockAttendanceAdjustmentApprovalListItem();
    var approval3 = MockAttendanceAdjustmentApprovalListItem();
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    when(() => listProvider.didReachListEnd).thenReturn(false);
    when(() => listProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getItemAtIndex(0), approval1);
    expect(presenter.getItemAtIndex(1), approval2);
    expect(presenter.getItemAtIndex(2), approval3);
  });

  //MARK: Tests remove approved or rejected items

  test("successfully performing action on one of three items updates the list", () async {
    //given
    when(() => listProvider.isLoading).thenReturn(false);
    var approval1 = MockAttendanceAdjustmentApprovalListItem();
    var approval2 = MockAttendanceAdjustmentApprovalListItem();
    var approval3 = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval1.id).thenReturn("id1");
    when(() => approval2.id).thenReturn("id2");
    when(() => approval3.id).thenReturn("id3");
    when(() => listProvider.getNext()).thenAnswer((_) => Future.value([approval1, approval2, approval3]));
    await presenter.getNext();
    _clearAllInteractions();

    //when
    await presenter.onDidProcessApprovalOrRejection(true, "id2");

    //then
    expect(presenter.numberOfApprovalsProcessed, 1);
    expect(presenter.getNumberOfListItems(), 3);
    expect(presenter.getItemTypeAtIndex(0), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(1), AttendanceAdjustmentApprovalListItemViewType.ListItem);
    expect(presenter.getItemTypeAtIndex(2), AttendanceAdjustmentApprovalListItemViewType.Loader);
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
    var approval1 = MockAttendanceAdjustmentApprovalListItem();
    var approval2 = MockAttendanceAdjustmentApprovalListItem();
    var approval3 = MockAttendanceAdjustmentApprovalListItem();
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
    expect(presenter.numberOfApprovalsProcessed, 3);
    verifyInOrder([
      () => view.onDidProcessAllApprovals(),
    ]);
    _verifyNoMoreInteractions();
  });

  test("does not reload data when processing approval or rejection with null or false", () async {
    presenter.onDidProcessApprovalOrRejection(null, "someAttendanceId");
    _verifyNoMoreInteractions();

    presenter.onDidProcessApprovalOrRejection(false, "someAttendanceId");
    _verifyNoMoreInteractions();
  });

  //MARK: Tests for getters

  test('test getting employee name', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.employeeName).thenReturn("Some employee name");

    expect(presenter.getEmployeeName(approval), "Some employee name");
  });

  test('test getting attendance date', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.attendanceDate).thenReturn(DateTime(2022, 08, 20));

    expect(presenter.getDate(approval), "20-Aug-2022");
  });

  test('test getting original attendance status', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.originalStatus).thenReturn(null);
    expect(presenter.getOriginalStatus(approval), "");

    when(() => approval.originalStatus).thenReturn(AttendanceStatus.Present);
    expect(presenter.getOriginalStatus(approval), "Present");
  });

  test('test getting original attendance status color', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.originalStatus).thenReturn(null);
    expect(presenter.getOriginalStatusColor(approval), null);

    when(() => approval.originalStatus).thenReturn(AttendanceStatus.Present);
    expect(presenter.getOriginalStatusColor(approval), AttendanceStatusColor.getStatusColor(AttendanceStatus.Present));
  });

  test('test getting adjusted attendance status', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.adjustedStatus).thenReturn(null);
    expect(presenter.getAdjustedStatus(approval), "");

    when(() => approval.adjustedStatus).thenReturn(AttendanceStatus.Present);
    expect(presenter.getAdjustedStatus(approval), "Present");
  });

  test('test getting adjusted attendance status color', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.adjustedStatus).thenReturn(null);
    expect(presenter.getAdjustedStatusColor(approval), null);

    when(() => approval.adjustedStatus).thenReturn(AttendanceStatus.Present);
    expect(presenter.getAdjustedStatusColor(approval), AttendanceStatusColor.getStatusColor(AttendanceStatus.Present));
  });

  test('test getting original punch in and out times', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.originalPunchInTime).thenReturn(null);
    when(() => approval.originalPunchOutTime).thenReturn(null);
    expect(presenter.getOriginalPunchInTime(approval), "");
    expect(presenter.getOriginalPunchOutTime(approval), "");

    when(() => approval.originalPunchInTime).thenReturn(DateTime(2022, 08, 20, 9, 30));
    when(() => approval.originalPunchOutTime).thenReturn(DateTime(2022, 08, 20, 18, 0));
    expect(presenter.getOriginalPunchInTime(approval), "09:30 AM");
    expect(presenter.getOriginalPunchOutTime(approval), "06:00 PM");
  });

  test('test getting adjusted punch in and out times', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.adjustedPunchInTime).thenReturn(DateTime(2022, 08, 20, 9, 30));
    when(() => approval.adjustedPunchOutTime).thenReturn(DateTime(2022, 08, 20, 18, 0));

    expect(presenter.getAdjustedPunchInTime(approval), "09:30 AM");
    expect(presenter.getAdjustedPunchOutTime(approval), "06:00 PM");
  });

  test('test getting adjustment reason', () {
    var approval = MockAttendanceAdjustmentApprovalListItem();
    when(() => approval.adjustmentReason).thenReturn("some reason");

    expect(presenter.getAdjustmentReason(approval), "some reason");
  });
}
