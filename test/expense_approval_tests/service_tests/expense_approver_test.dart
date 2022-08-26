import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/expense_approval/constants/expense_approval_urls.dart';
import 'package:wallpost/expense_approval/entities/expense_approval.dart';
import 'package:wallpost/expense_approval/services/expense_approver.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockExpenseApproval extends Mock implements ExpenseApproval {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var approval = MockExpenseApproval();
  var mockNetworkAdapter = MockNetworkAdapter();
  var approver = ExpenseApprover.initWith(mockNetworkAdapter);

  setUpAll(() {
    when(() => approval.id).thenReturn("someApprovalId");
    when(() => approval.companyId).thenReturn("someCompanyId");
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll({"app_type": "expenseRequest", "request_id": "someApprovalId"});
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve(approval);

    expect(mockNetworkAdapter.apiRequest.url, ExpenseApprovalUrls.approveUrl("someCompanyId"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve(approval);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await approver.approve(approval);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    approver.approve(approval);

    expect(approver.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve(approval);

    expect(approver.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve(approval);
      fail('failed to throw exception');
    } catch (_) {
      expect(approver.isLoading, false);
    }
  });
}
