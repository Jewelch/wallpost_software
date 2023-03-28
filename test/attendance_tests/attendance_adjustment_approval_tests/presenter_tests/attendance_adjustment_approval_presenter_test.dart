import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/services/attendance_adjustment_approver.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/services/attendance_adjustment_rejector.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/view_contracts/attendance_adjustment_approval_view.dart';

import '../../../_mocks/mock_notification_center.dart';

class MockAttendanceAdjustmentApprovalView extends Mock implements AttendanceAdjustmentApprovalView {}

class MockAttendanceAdjustmentApprover extends Mock implements AttendanceAdjustmentApprover {}

class MockAttendanceAdjustmentRejector extends Mock implements AttendanceAdjustmentRejector {}

void main() {
  var view = MockAttendanceAdjustmentApprovalView();
  var approver = MockAttendanceAdjustmentApprover();
  var rejector = MockAttendanceAdjustmentRejector();
  var notificationCenter = MockNotificationCenter();
  late AttendanceAdjustmentApprovalPresenter presenter;

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(approver);
    verifyNoMoreInteractions(rejector);
    verifyNoMoreInteractions(notificationCenter);
  }

  void _clearAllInteractions() {
    clearInteractions(view);
    clearInteractions(approver);
    clearInteractions(rejector);
    clearInteractions(notificationCenter);
  }

  setUp(() {
    _clearAllInteractions();
    when(() => notificationCenter.updateCount()).thenAnswer((_) => Future.value(null));
    presenter = AttendanceAdjustmentApprovalPresenter.initWith(view, approver, rejector, notificationCenter);
  });

  test('failure to approve', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.approve("someCompanyId", "someAttendanceId");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => approver.approve("someCompanyId", "someAttendanceId"),
      () => view.onDidFailToPerformAction("Approval Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully approving a request', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));

    //when
    await presenter.approve("someCompanyId", "someAttendanceId");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => approver.approve("someCompanyId", "someAttendanceId"),
      () => notificationCenter.updateCount(),
      () => view.onDidPerformActionSuccessfully("someAttendanceId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('does nothing when approving once again after successfully approving a request', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));
    await presenter.approve("someCompanyId", "someAttendanceId");
    _clearAllInteractions();

    //when
    await presenter.approve("someCompanyId", "someAttendanceId");

    //then
    _verifyNoMoreInteractions();
  });

  test('notifying invalid rejection reason', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.reject("someCompanyId", "someAttendanceId", "");

    //then
    expect(presenter.getRejectionReasonError(), "Please enter a valid reason");
    verifyInOrder([
      () => view.notifyInvalidRejectionReason("Please enter a valid reason"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to reject', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.reject("someCompanyId", "someAttendanceId", "some reason");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => rejector.reject("someCompanyId", "someAttendanceId", rejectionReason: "some reason"),
      () => view.onDidFailToPerformAction("Rejection Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));

    //when
    await presenter.reject("someCompanyId", "someAttendanceId", "some reason");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => rejector.reject("someCompanyId", "someAttendanceId", rejectionReason: "some reason"),
      () => notificationCenter.updateCount(),
      () => view.onDidPerformActionSuccessfully("someAttendanceId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('does nothing when rejecting once again after successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));
    await presenter.reject("someCompanyId", "someAttendanceId", "some reason");
    _clearAllInteractions();

    //when
    await presenter.reject("someCompanyId", "someAttendanceId", "some reason");

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
    await presenter.approve("someCompanyId", "someAttendanceId");

    expect(presenter.getApproveButtonTitle(), "Approved!");
  });

  test("getting reject button title before successful rejection", () {
    expect(presenter.getRejectButtonTitle(), "Submit");
  });

  test("getting reject button title after successful rejection", () async {
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));
    await presenter.reject("someCompanyId", "someAttendanceId", "some reason");

    expect(presenter.getRejectButtonTitle(), "Rejected!");
  });
}
