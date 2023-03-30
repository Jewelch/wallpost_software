import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/services/purchase_bill_approver.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/services/purchase_bill_rejector.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/presenters/purchase_bill_approval_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/view_contracts/purchase_bill_approval_view.dart';

import '../../../_mocks/mock_network_adapter.dart';
import '../../../_mocks/mock_notification_center.dart';

class MockPurchaseBillApprovalView extends Mock implements PurchaseBillApprovalView {}

class MockPurchaseBillApproval extends Mock implements PurchaseBillApproval {}

class MockPurchaseBillRejector extends Mock implements PurchaseBillRejector {}

void main() {
  var view = MockPurchaseBillApprovalView();
  var approver = MockPurchaseBillApproval();
  var rejector = MockPurchaseBillRejector();
  var notificationCenter = MockNotificationCenter();
  late PurchaseBillApprovalPresenter presenter;

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
    presenter = PurchaseBillApprovalPresenter.initWith(view, approver, rejector, notificationCenter);
  });

  test('failure to approve', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.approve("someCompanyId", "someBillId");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => approver.approve("someCompanyId", "someBillId"),
      () => view.onDidFailToPerformAction("Approval Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully approving a request', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));

    //when
    await presenter.approve("someCompanyId", "someBillId");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => approver.approve("someCompanyId", "someBillId"),
      () => notificationCenter.updateCount(),
      () => view.onDidPerformActionSuccessfully("someBillId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('does nothing when approving once again after successfully approving a request', () async {
    //given
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.value(null));
    await presenter.approve("someCompanyId", "someBillId");
    _clearAllInteractions();

    //when
    await presenter.approve("someCompanyId", "someBillId");

    //then
    _verifyNoMoreInteractions();
  });

  test('notifying invalid rejection reason', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.reject("someCompanyId", "someBillId", "");

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
    await presenter.reject("someCompanyId", "someBillId", "some reason");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => rejector.reject("someCompanyId", "someBillId", rejectionReason: "some reason"),
      () => view.onDidFailToPerformAction("Rejection Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));

    //when
    await presenter.reject("someCompanyId", "someBillId", "some reason");

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => rejector.reject("someCompanyId", "someBillId", rejectionReason: "some reason"),
      () => notificationCenter.updateCount(),
      () => view.onDidPerformActionSuccessfully("someBillId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('does nothing when rejecting once again after successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));
    await presenter.reject("someCompanyId", "someBillId", "some reason");
    _clearAllInteractions();

    //when
    await presenter.reject("someCompanyId", "someBillId", "some reason");

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
    await presenter.approve("someCompanyId", "someBillId");

    expect(presenter.getApproveButtonTitle(), "Approved!");
  });

  test("getting reject button title before successful rejection", () {
    expect(presenter.getRejectButtonTitle(), "Submit");
  });

  test("getting reject button title after successful rejection", () async {
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));
    await presenter.reject("someCompanyId", "someBillId", "some reason");

    expect(presenter.getRejectButtonTitle(), "Rejected!");
  });
}
