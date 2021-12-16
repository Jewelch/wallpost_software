// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/leave/constants/leave_urls.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/services/leave_list_provider.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  List<Map<String, dynamic>> successfulResponse = Mocks.leaveListResponse;
  var mockEmployee = MockEmployee();
  var filters = LeaveListFilters();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var leaveListProvider = LeaveListProvider.initWith(mockEmployeeProvider, mockNetworkAdapter);

  setUpAll(() {
    when(mockEmployee.companyId).thenReturn('someCompanyId');
    when(mockEmployee.v1Id).thenReturn('v1EmpId');
    when(mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await leaveListProvider.getNext(filters);

    expect(mockNetworkAdapter.apiRequest.url, LeaveUrls.leaveListUrl('someCompanyId', 'v1EmpId', filters, 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await leaveListProvider.getNext(filters);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    leaveListProvider.getNext(filters).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    leaveListProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    leaveListProvider.getNext(filters).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await leaveListProvider.getNext(filters);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await leaveListProvider.getNext(filters);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await leaveListProvider.getNext(filters);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var leaveListItem = await leaveListProvider.getNext(filters);
      expect(leaveListItem, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    leaveListProvider.reset();
    try {
      expect(leaveListProvider.getCurrentPageNumber(), 1);
      await leaveListProvider.getNext(filters);
      expect(leaveListProvider.getCurrentPageNumber(), 2);
      await leaveListProvider.getNext(filters);
      expect(leaveListProvider.getCurrentPageNumber(), 3);
      await leaveListProvider.getNext(filters);
      expect(leaveListProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    leaveListProvider.getNext(filters);

    expect(leaveListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await leaveListProvider.getNext(filters);

    expect(leaveListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await leaveListProvider.getNext(filters);
      fail('failed to throw exception');
    } catch (_) {
      expect(leaveListProvider.isLoading, false);
    }
  });
}
