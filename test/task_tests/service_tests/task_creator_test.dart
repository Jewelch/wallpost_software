import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/create_task_form.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/services/task_creator.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockTaskEmployee extends Mock implements TaskEmployee {}

void main() {
  var mockTaskEmployee1 = MockTaskEmployee();
  var mockTaskEmployee2 = MockTaskEmployee();
  var createTaskForm = CreateTaskForm(
    name: 'Some task name',
    description: 'Some task description',
    startDate: DateTime(2020, 11, 30),
    startTime: DateTime(2020, 11, 30, 9, 30, 00),
    endDate: DateTime(2020, 11, 30),
    endTime: DateTime(2020, 11, 30, 17, 30, 00),
    assignees: [mockTaskEmployee1, mockTaskEmployee2],
    attachedFileNames: ['filename1', 'filename2'],
    isAttachmentRequiredOnCompletion: true,
    timezone: 'TimeZoneString',
  );
  Map<String, dynamic> successfulResponse = Mocks.createTaskResponse;
  var mockCompany = MockCompany();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var taskCreator = TaskCreator.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    when(mockCompany.id).thenReturn('someCompanyId');
    when(mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(createTaskForm.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await taskCreator.create(createTaskForm);

    expect(mockNetworkAdapter.apiRequest.url, TaskUrls.createTaskUrl('someCompanyId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPostWithNonce, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await taskCreator.create(createTaskForm);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await taskCreator.create(createTaskForm);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await taskCreator.create(createTaskForm);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await taskCreator.create(createTaskForm);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var createTaskResponse = await taskCreator.create(createTaskForm);
      expect(createTaskResponse, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    taskCreator.create(createTaskForm);

    expect(taskCreator.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await taskCreator.create(createTaskForm);

    expect(taskCreator.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await taskCreator.create(createTaskForm);
      fail('failed to throw exception');
    } catch (_) {
      expect(taskCreator.isLoading, false);
    }
  });
}
