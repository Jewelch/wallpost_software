import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/my_portal/constants/my_portal_urls.dart';
import 'package:wallpost/my_portal/services/pending_actions_count_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.pendingActionsCountResponse;
  var mockCompany = MockCompany();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var pendingActionsCountProvider = PendingActionsCountProvider.initWith(mockCompanyProvider, mockNetworkAdapter);

  setUpAll(() {
    when(mockCompany.id).thenReturn('someCompanyId');
    when(mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await pendingActionsCountProvider.getCount();

    expect(mockNetworkAdapter.apiRequest.url, MyPortalUrls.pendingActionsCountUrl('someCompanyId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await pendingActionsCountProvider.getCount();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    pendingActionsCountProvider.getCount().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    pendingActionsCountProvider.getCount().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await pendingActionsCountProvider.getCount();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await pendingActionsCountProvider.getCount();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await pendingActionsCountProvider.getCount();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var pendingActionsCount = await pendingActionsCountProvider.getCount();
      expect(pendingActionsCount, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    pendingActionsCountProvider.getCount();

    expect(pendingActionsCountProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await pendingActionsCountProvider.getCount();

    expect(pendingActionsCountProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await pendingActionsCountProvider.getCount();
      fail('failed to throw exception');
    } catch (_) {
      expect(pendingActionsCountProvider.isLoading, false);
    }
  });
}
