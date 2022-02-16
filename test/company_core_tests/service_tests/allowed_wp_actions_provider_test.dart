import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/company_core/constants/company_management_urls.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';
import 'package:wallpost/company_core/services/allowed_wp_actions_provider.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockAllowedActionsRepository extends Mock implements AllowedActionsRepository {}

class MockSelectedEmployeeProvider extends Mock implements SelectedEmployeeProvider {}

class MockEmployee extends Mock implements Employee {}

void main() {
  //TODO ABDO
  var successfulResponse = Mocks.wpActionsListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockEmployee = MockEmployee();
  var mockSelectedEmployeeProvider = MockSelectedEmployeeProvider();
  var repository = MockAllowedActionsRepository();
  late AllowedWPActionsProvider allowedActionsProvider;

  setUpAll(() {
    registerFallbackValue(MockEmployee());
    when(mockSelectedEmployeeProvider.getSelectedEmployeeForCurrentUser).thenReturn(mockEmployee);
    allowedActionsProvider = AllowedWPActionsProvider.initWith(
        mockNetworkAdapter, mockSelectedEmployeeProvider, repository);
  });

  var companyId = "13";

  test('api request is built correctly', () async {
    when(() => repository.saveActionsForEmployee(any(), any()))
        .thenAnswer((_) => Future.value(null));
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await allowedActionsProvider.get(companyId);

    expect(
        mockNetworkAdapter.apiRequest.url, CompanyManagementUrls.getAllowedActionsUrl(companyId));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    clearInteractions(repository);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await allowedActionsProvider.get(companyId);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await allowedActionsProvider.get(companyId);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    allowedActionsProvider.get('someCompanyId');

    expect(allowedActionsProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await allowedActionsProvider.get('someCompanyId');

    expect(allowedActionsProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await allowedActionsProvider.get('someCompanyId');
      fail('failed to throw exception');
    } catch (_) {
      expect(allowedActionsProvider.isLoading, false);
    }
  });

  test('response is ignored if it is from another session', () async {
    when(() => repository.saveActionsForEmployee(any(), any()))
        .thenAnswer((_) => Future.value(null));
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    allowedActionsProvider.get(companyId).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    allowedActionsProvider.get(companyId).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await allowedActionsProvider.get(companyId);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    when(() => repository.saveActionsForEmployee(any(), any()))
        .thenAnswer((_) => Future.value(null));
    mockNetworkAdapter.succeed([
      <String, dynamic>{"miss_data": "anyWrongData"}
    ]);

    try {
      var _ = await allowedActionsProvider.get(companyId);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      print(e.runtimeType);
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await allowedActionsProvider.get(companyId);
      verify(() => repository.saveActionsForEmployee(any(), any()));
      verifyNoMoreInteractions(repository);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
