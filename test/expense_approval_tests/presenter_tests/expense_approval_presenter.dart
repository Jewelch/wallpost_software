import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense_approval/entities/expense_approval.dart';
import 'package:wallpost/expense_approval/services/expense_approver.dart';
import 'package:wallpost/expense_approval/services/expense_rejector.dart';
import 'package:wallpost/expense_approval/ui/presenters/expense_approval_presenter.dart';
import 'package:wallpost/expense_approval/ui/view_contracts/expense_approval_view.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockExpenseApprovalView extends Mock implements ExpenseApprovalView {}

class MockExpenseApproval extends Mock implements ExpenseApproval {}

class MockExpenseApprover extends Mock implements ExpenseApprover {}

class MockExpenseRejector extends Mock implements ExpenseRejector {}

void main() {
  var view = MockExpenseApprovalView();
  var approver = MockExpenseApprover();
  var rejector = MockExpenseRejector();
  late ExpenseApprovalPresenter presenter;

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
    registerFallbackValue(MockExpenseApproval());
  });

  setUp(() {
    _clearAllInteractions();
    presenter = ExpenseApprovalPresenter.initWith(view, approver, rejector);
  });

  test('failure to approve', () async {
    //given
    when(() => approver.approve(any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    var approval = MockExpenseApproval();
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
    var approval = MockExpenseApproval();
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
    var approval = MockExpenseApproval();
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
    var approval = MockExpenseApproval();
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
