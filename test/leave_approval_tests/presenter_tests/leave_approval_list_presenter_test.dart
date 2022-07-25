import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval_status.dart';
import 'package:wallpost/leave_approvals/services/leave_approval_list_provider.dart';
import 'package:wallpost/leave_approvals/ui/models/leave_approval_list_view_type.dart';
import 'package:wallpost/leave_approvals/ui/presenters/leave_approval_list_presenter.dart';
import 'package:wallpost/leave_approvals/ui/view_contracts/leave_approval_list_view.dart';

class MockLeaveApprovalListView extends Mock implements LeaveApprovalListView {}

class MockLeaveApprovalListProvider extends Mock implements LeaveApprovalListProvider {}

class MockLeaveApproval extends Mock implements LeaveApproval {}

void main() {
  var view = MockLeaveApprovalListView();
  var leaveListProvider = MockLeaveApprovalListProvider();
  late LeaveApprovalListPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(leaveListProvider);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(leaveListProvider);
  }

  setUpAll(() {
    registerFallbackValue(LeaveApprovalStatus.all);
  });

  setUp(() {
    _clearAllInteractions();
    presenter = LeaveApprovalListPresenter.initWith(view, leaveListProvider);
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
      () => leaveListProvider.getNext(LeaveApprovalStatus.all),
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
      () => view.showErrorMessage("There are no leave approvals to show.\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully loading the leave list with items', () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveApproval(),
          MockLeaveApproval(),
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
          MockLeaveApproval(),
          MockLeaveApproval(),
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
          MockLeaveApproval(),
          MockLeaveApproval(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveApproval(),
          MockLeaveApproval(),
          MockLeaveApproval(),
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
          MockLeaveApproval(),
          MockLeaveApproval(),
          MockLeaveApproval(),
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
          MockLeaveApproval(),
          MockLeaveApproval(),
          MockLeaveApproval(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(false);
    when(() => leaveListProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(1), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(2), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(3), LeaveApprovalListViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items', () async {
    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveApproval(),
          MockLeaveApproval(),
          MockLeaveApproval(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(false);
    when(() => leaveListProvider.isLoading).thenReturn(true);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(1), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(2), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(3), LeaveApprovalListViewType.Loader);
  });

  test('get number of list items when there are some items and the provider has more items but fails to load them',
      () async {
    //given
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveApproval(),
          MockLeaveApproval(),
          MockLeaveApproval(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(false);
    when(() => leaveListProvider.isLoading).thenReturn(false);

    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.getNext();

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(1), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(2), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(3), LeaveApprovalListViewType.ErrorMessage);
  });

  test('get number of list items when there are some items and the provider has no more items', () async {
    //when
    when(() => leaveListProvider.getNext(any())).thenAnswer((_) => Future.value([
          MockLeaveApproval(),
          MockLeaveApproval(),
          MockLeaveApproval(),
        ]));
    await presenter.getNext();
    when(() => leaveListProvider.didReachListEnd).thenReturn(true);
    when(() => leaveListProvider.isLoading).thenReturn(false);

    //then
    expect(presenter.getNumberOfListItems(), 4);
    expect(presenter.getItemTypeAtIndex(0), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(1), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(2), LeaveApprovalListViewType.List);
    expect(presenter.getItemTypeAtIndex(3), LeaveApprovalListViewType.EmptySpace);
  });
}
