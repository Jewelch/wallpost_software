import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';
import 'package:wallpost/sales_data/constants/sales_data_url.dart';
import 'package:wallpost/sales_data/services/sales_data_provider.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_company_repository.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.salesDataRandomResponse;
  var mockNetworkAdapter = MockNetworkAdapter();

  var mockCurrentUserProvider = MockCurrentUserProvider();
  var mockCompanyRepository = MockCompanyRepository();
  var mockSelectedCompanyProvider = MockCompanyProvider();

  var salesDataProvider = SalesDataProvider.initWith(mockNetworkAdapter, mockSelectedCompanyProvider);

  setUpAll(() {
    final mockCompany = MockCompany();
    final user = User.fromJson(Mocks.userMapWithInactiveSession);
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockCurrentUserProvider.getCurrentUser()).thenReturn(user);
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(mockCompany);
  });

  setUp(() {
    reset(mockCurrentUserProvider);
    reset(mockCompanyRepository);
  });

  test('SalesAmounts API request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    await salesDataProvider.getSalesAmounts(storeId: 'someStoreId');

    expect(mockNetworkAdapter.apiRequest.url, SalesDataUrls.getSalesAmountsUrl('someCompanyId', 'someStoreId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, isTrue);
  });

  test('SalesAmounts API throws <NetworkFailureException> when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await salesDataProvider.getSalesAmounts(storeId: 'someStoreId');
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e, isA<NetworkFailureException>());
    }
  });

  test('SalesAmounts API throws <InvalidResponseException> when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      await salesDataProvider.getSalesAmounts(storeId: 'someStoreId');
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesAmounts API throws <WrongResponseFormatException> when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      await salesDataProvider.getSalesAmounts(storeId: 'someStoreId');
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('SalesAmounts API throws <InvalidResponseException> when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{"miss_data": "anyWrongData"});

    try {
      await salesDataProvider.getSalesAmounts(storeId: 'someStoreId');
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('SalesAmounts API response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    salesDataProvider.getSalesAmounts().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    salesDataProvider.getSalesAmounts().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('SalesAmounts API succeeds', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await salesDataProvider.getSalesAmounts(storeId: "someStoreId");
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
