import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/services/tasks_list_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  var filters = TasksListFilters();
  List<Map<String, dynamic>> successfulResponse = Mocks.tasksListResponse;
  var mockCompany = MockCompany();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var tasksListProvider = TasksListProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    when(mockCompany.id).thenReturn('someCompanyId');
    when(mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  setUpAll(() {
    filters.showTeamTasks();
    filters.showCompletedTasks();
    filters.year = 2019;
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await tasksListProvider.getNext(filters);

    expect(mockNetworkAdapter.apiRequest.url, TaskUrls.tasksListUrl('someCompanyId', filters, 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await tasksListProvider.getNext(filters);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    tasksListProvider.getNext(filters).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    tasksListProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    tasksListProvider.getNext(filters).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await tasksListProvider.getNext(filters);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await tasksListProvider.getNext(filters);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await tasksListProvider.getNext(filters);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var taskListItem = await tasksListProvider.getNext(filters);
      expect(taskListItem, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    tasksListProvider.reset();
    try {
      expect(tasksListProvider.getCurrentPageNumber(), 1);
      await tasksListProvider.getNext(filters);
      expect(tasksListProvider.getCurrentPageNumber(), 2);
      await tasksListProvider.getNext(filters);
      expect(tasksListProvider.getCurrentPageNumber(), 3);
      await tasksListProvider.getNext(filters);
      expect(tasksListProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      print(e);
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    tasksListProvider.getNext(filters);

    expect(tasksListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await tasksListProvider.getNext(filters);

    expect(tasksListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await tasksListProvider.getNext(filters);
      fail('failed to throw exception');
    } catch (_) {
      expect(tasksListProvider.isLoading, false);
    }
  });
}
