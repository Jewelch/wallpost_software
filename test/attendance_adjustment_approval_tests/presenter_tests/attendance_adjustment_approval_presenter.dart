import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_approver.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_rejector.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/view_contracts/attendance_adjustment_approval_view.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceAdjustmentApprovalView extends Mock implements AttendanceAdjustmentApprovalView {}

class MockAttendanceAdjustmentApproval extends Mock implements AttendanceAdjustmentApproval {}

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

  setUpAll(() {
    registerFallbackValue(MockAttendanceAdjustmentApproval());
  });

  setUp(() {
    _clearAllInteractions();
    presenter = AttendanceAdjustmentApprovalPresenter.initWith(view, approver, rejector);
  });

  test('failure to approve', () async {
    //given
    when(() => approver.approve(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    var approval = MockAttendanceAdjustmentApproval();
    await presenter.approve(approval);

    //then
    verifyInOrder([
      () => approver.approve(approval),
      () => view.onDidFailToApproveOrReject("Approval Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully approving a request', () async {
    //given
    when(() => approver.approve(any())).thenAnswer((_) => Future.value(null));

    //when
    var approval = MockAttendanceAdjustmentApproval();
    await presenter.approve(approval);

    //then
    verifyInOrder([
      () => approver.approve(approval),
      () => view.onDidApproveOrRejectSuccessfully(approval),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to reject', () async {
    //given
    when(() => rejector.reject(any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    var approval = MockAttendanceAdjustmentApproval();
    var didRejectSuccessfully = await presenter.reject(approval, "some reason");

    //then
    expect(didRejectSuccessfully, false);
    verifyInOrder([
      () => rejector.reject(approval, rejectionReason: "some reason"),
      () => view.onDidFailToApproveOrReject("Rejection Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));

    //when
    var approval = MockAttendanceAdjustmentApproval();
    var didRejectSuccessfully = await presenter.reject(approval, "some reason");

    //then
    expect(didRejectSuccessfully, true);
    verifyInOrder([
      () => rejector.reject(approval, rejectionReason: "some reason"),
      () => view.onDidApproveOrRejectSuccessfully(approval),
    ]);
    _verifyNoMoreInteractions();
  });
}
