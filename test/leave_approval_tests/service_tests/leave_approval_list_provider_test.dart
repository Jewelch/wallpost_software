import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/leave_approvals/constants/leave_approval_urls.dart';
import 'package:wallpost/leave_approvals/entities/leave_approval_status.dart';
import 'package:wallpost/leave_approvals/services/leave_approval_list_provider.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.leaveApprovalListResponse;
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var approvalListProvider = LeaveApprovalListProvider.initWith(mockEmployeeProvider, mockNetworkAdapter);

  setUpAll(() {
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);

    expect(mockNetworkAdapter.apiRequest.url,
        LeaveApprovalUrls.leaveApprovalListUrl('someCompanyId', LeaveApprovalStatus.all, 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    approvalListProvider.getNext(LeaveApprovalStatus.all).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    approvalListProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    await approvalListProvider.getNext(LeaveApprovalStatus.all).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var leaveApprovalList = await approvalListProvider.getNext(LeaveApprovalStatus.all);
      expect(leaveApprovalList.length, 5);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    approvalListProvider.reset();
    try {
      expect(approvalListProvider.getCurrentPageNumber(), 1);
      await approvalListProvider.getNext(LeaveApprovalStatus.all);
      expect(approvalListProvider.getCurrentPageNumber(), 2);
      await approvalListProvider.getNext(LeaveApprovalStatus.all);
      expect(approvalListProvider.getCurrentPageNumber(), 3);
      await approvalListProvider.getNext(LeaveApprovalStatus.all);
      expect(approvalListProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    approvalListProvider.getNext(LeaveApprovalStatus.all);

    expect(approvalListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);

    expect(approvalListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approvalListProvider.getNext(LeaveApprovalStatus.all);
      fail('failed to throw exception');
    } catch (_) {
      expect(approvalListProvider.isLoading, false);
    }
  });
}
