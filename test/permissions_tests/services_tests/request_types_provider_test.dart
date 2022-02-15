import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/permission/constants/permissions_urls.dart';
import 'package:wallpost/permission/repositories/request_items_repository.dart';
import 'package:wallpost/permission/services/allowed_wp_actions_provider.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../_mocks/mocks.dart' as Mocks;

class MockRequestItemsRepository extends Mock implements RequestItemsRepository {}

void main() {
  var successfulResponse = Mocks.requestItemsListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var repository = MockRequestItemsRepository();
  var requestItemsProvider =
      AllowedWPActionsProvider.initWith(mockNetworkAdapter, repository);
  var companyId = "13";

  test('api request is built correctly', () async {
    when(() => repository.saveRequestItemsForEmployee(any(), any()))
        .thenAnswer((_) => Future.value(null));
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await requestItemsProvider.get(companyId);

    expect(mockNetworkAdapter.apiRequest.url, PermissionsUrls.getRequestItemsUrl(companyId));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    clearInteractions(repository);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await requestItemsProvider.get(companyId);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await requestItemsProvider.get(companyId);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    requestItemsProvider.get('someCompanyId');

    expect(requestItemsProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await requestItemsProvider.get('someCompanyId');

    expect(requestItemsProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await requestItemsProvider.get('someCompanyId');
      fail('failed to throw exception');
    } catch (_) {
      expect(requestItemsProvider.isLoading, false);
    }
  });

  test('response is ignored if it is from another session', () async {
    when(() => repository.saveRequestItemsForEmployee(any(), any()))
        .thenAnswer((_) => Future.value(null));
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    requestItemsProvider.get(companyId).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    requestItemsProvider.get(companyId).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await requestItemsProvider.get(companyId);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    when(() => repository.saveRequestItemsForEmployee(any(), any()))
        .thenAnswer((_) => Future.value(null));
    mockNetworkAdapter.succeed([
      <String, dynamic>{"miss_data": "anyWrongData"}
    ]);

    try {
      var _ = await requestItemsProvider.get(companyId);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      print(e.runtimeType);
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await requestItemsProvider.get(companyId);
      verify(() => repository.saveRequestItemsForEmployee(any(), any()));
      verifyNoMoreInteractions(repository);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });


}
