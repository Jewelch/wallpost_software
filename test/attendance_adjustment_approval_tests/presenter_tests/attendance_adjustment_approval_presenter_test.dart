import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_approver.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_rejector.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance_adjustment_approval_list/ui/view_contracts/attendance_adjustment_approval_view.dart';

class MockAttendanceAdjustmentApprovalView extends Mock implements AttendanceAdjustmentApprovalView {}

class MockAttendanceAdjustmentApprover extends Mock implements AttendanceAdjustmentApprover {}

class MockAttendanceAdjustmentRejector extends Mock implements AttendanceAdjustmentRejector {}

void main() {
  var view = MockAttendanceAdjustmentApprovalView();
  var approver = MockAttendanceAdjustmentApprover();
  var rejector = MockAttendanceAdjustmentRejector();
  late AttendanceAdjustmentApprovalPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(approver);
    verifyNoMoreInteractions(rejector);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(approver);
    clearInteractions(rejector);
  }

  setUp(() {
    presenter = AttendanceAdjustmentApprovalPresenter.initWith(view, approver, rejector);
  });

  test('failure to approve', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.approve("someCompanyId", "someExpenseId");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => approver.approve("someCompanyId", "someExpenseId"),
      () => view.onDidFailToPerformAction("Approval Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully approving a request', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));

    //when
    await presenter.approve("someCompanyId", "someExpenseId");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => approver.approve("someCompanyId", "someExpenseId"),
      () => view.onDidPerformActionSuccessfully("someExpenseId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('does nothing when approving once again after successfully approving a request', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));
    await presenter.approve("someCompanyId", "someExpenseId");
    _clearAllInteractions();

    //when
    await presenter.approve("someCompanyId", "someExpenseId");

    //then
    _verifyNoMoreInteractions();
  });

  test('notifying invalid rejection reason', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.reject("someCompanyId", "someExpenseId", "");

    //then
    expect(presenter.getRejectionReasonError(), "Please enter a valid reason");
    verifyInOrder([
      () => view.notifyInvalidRejectionReason(),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to reject', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.reject("someCompanyId", "someExpenseId", "some reason");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => rejector.reject("someCompanyId", "someExpenseId", rejectionReason: "some reason"),
      () => view.onDidFailToPerformAction("Rejection Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));

    //when
    await presenter.reject("someCompanyId", "someExpenseId", "some reason");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => rejector.reject("someCompanyId", "someExpenseId", rejectionReason: "some reason"),
      () => view.onDidPerformActionSuccessfully("someExpenseId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('does nothing when rejecting once again after successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));
    await presenter.reject("someCompanyId", "someExpenseId", "some reason");
    _clearAllInteractions();

    //when
    await presenter.reject("someCompanyId", "someExpenseId", "some reason");

    //then
    _verifyNoMoreInteractions();
  });

  test("checking if approval in progress", () {
    when(() => approver.isLoading).thenReturn(true);
    expect(presenter.isApprovalInProgress(), true);

    when(() => approver.isLoading).thenReturn(false);
    expect(presenter.isApprovalInProgress(), false);
  });

  test("checking if rejection in progress", () {
    when(() => rejector.isLoading).thenReturn(true);
    expect(presenter.isRejectionInProgress(), true);

    when(() => rejector.isLoading).thenReturn(false);
    expect(presenter.isRejectionInProgress(), false);
  });

  test("getting approve button title before successful approval", () {
    expect(presenter.getApproveButtonTitle(), "Submit");
  });

  test("getting approve button title after successful approval", () async {
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));
    await presenter.approve("someCompanyId", "someExpenseId");

    expect(presenter.getApproveButtonTitle(), "Approved!");
  });

  test("getting reject button title before successful rejection", () {
    expect(presenter.getRejectButtonTitle(), "Submit");
  });

  test("getting reject button title after successful rejection", () async {
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));
    await presenter.reject("someCompanyId", "someExpenseId", "some reason");

    expect(presenter.getRejectButtonTitle(), "Rejected!");
  });
}
