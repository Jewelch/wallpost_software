import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/company_management/constants/company_management_urls.dart';
import 'package:wallpost/company_management/services/company_list_provider.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  var successfulResponse = Mocks.companiesListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var companyListProvider = CompanyListProvider.initWith(mockNetworkAdapter);

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await companyListProvider.get();

    expect(mockNetworkAdapter.apiRequest.url, CompanyManagementUrls.getCompaniesUrl('0', '15'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await companyListProvider.get();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await companyListProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await companyListProvider.get();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await companyListProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var company = await companyListProvider.get();
      expect(company, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    companyListProvider.reset();
    try {
      expect(companyListProvider.getCurrentPageNumber(), 0);
      await companyListProvider.get();
      expect(companyListProvider.getCurrentPageNumber(), 1);
      await companyListProvider.get();
      expect(companyListProvider.getCurrentPageNumber(), 2);
      await companyListProvider.get();
      expect(companyListProvider.getCurrentPageNumber(), 3);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
