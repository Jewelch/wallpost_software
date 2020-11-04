import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/services/task_employees_list_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  List<Map<String, dynamic>> successfulResponse = Mocks.taskAssigneesListResponse;

  var mockCompany = MockCompany();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var taskAssigneesListProvider = TaskEmployeesListProvider.initWith(
    mockCompanyProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    when(mockCompany.id).thenReturn('someCompanyId');
    when(mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await taskAssigneesListProvider.getNext();

    expect(mockNetworkAdapter.apiRequest.url, TaskUrls.assigneesUrl('someCompanyId', 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await taskAssigneesListProvider.getNext();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    taskAssigneesListProvider.getNext().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    taskAssigneesListProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    taskAssigneesListProvider.getNext().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await taskAssigneesListProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await taskAssigneesListProvider.getNext();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await taskAssigneesListProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var taskAssignee = await taskAssigneesListProvider.getNext();
      expect(taskAssignee, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    taskAssigneesListProvider.reset();
    try {
      expect(taskAssigneesListProvider.getCurrentPageNumber(), 1);
      await taskAssigneesListProvider.getNext();
      expect(taskAssigneesListProvider.getCurrentPageNumber(), 2);
      await taskAssigneesListProvider.getNext();
      expect(taskAssigneesListProvider.getCurrentPageNumber(), 3);
      await taskAssigneesListProvider.getNext();
      expect(taskAssigneesListProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    taskAssigneesListProvider.getNext();

    expect(taskAssigneesListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await taskAssigneesListProvider.getNext();

    expect(taskAssigneesListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await taskAssigneesListProvider.getNext();
      fail('failed to throw exception');
    } catch (_) {
      expect(taskAssigneesListProvider.isLoading, false);
    }
  });
}
