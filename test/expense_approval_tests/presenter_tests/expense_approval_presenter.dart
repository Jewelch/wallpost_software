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
    when(() => approver.approve(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.approve("someCompanyId", "someExpenseId");

    //then
    verifyInOrder([
      () => approver.approve("someCompanyId", "someExpenseId"),
      () => view.onDidFailToApproveOrReject("Approval Failed", InvalidResponseException().userReadableMessage),
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
      () => approver.approve("someCompanyId", "someExpenseId"),
      () => view.onDidApproveOrRejectSuccessfully("someExpenseId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test('failure to reject', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    var didRejectSuccessfully = await presenter.reject("someCompanyId", "someExpenseId", "some reason");

    //then
    expect(didRejectSuccessfully, false);
    verifyInOrder([
      () => rejector.reject("someCompanyId", "someExpenseId", rejectionReason: "some reason"),
      () => view.onDidFailToApproveOrReject("Rejection Failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractions();
  });

  test('successfully rejecting a request', () async {
    //given
    when(() => rejector.reject(any(), any(), rejectionReason: any(named: "rejectionReason")))
        .thenAnswer((_) => Future.value(null));

    //when
    var didRejectSuccessfully = await presenter.reject("someCompanyId", "someExpenseId", "some reason");

    //then
    expect(didRejectSuccessfully, true);
    verifyInOrder([
      () => rejector.reject("someCompanyId", "someExpenseId", rejectionReason: "some reason"),
      () => view.onDidApproveOrRejectSuccessfully("someExpenseId"),
    ]);
    _verifyNoMoreInteractions();
  });

  test(
      "didPerformAction flag is set to true when the approve function is called "
      "irrespective of the outcome", () {
    expect(presenter.didPerformAction, false);

    presenter.approve("companyId", "expenseId");

    expect(presenter.didPerformAction, true);
  });

  test(
      "didPerformAction flag is set to true when the reject function is called "
      "irrespective of the outcome", () {
    expect(presenter.didPerformAction, false);

    presenter.reject("companyId", "expenseId", "reason");

    expect(presenter.didPerformAction, true);
  });
}
