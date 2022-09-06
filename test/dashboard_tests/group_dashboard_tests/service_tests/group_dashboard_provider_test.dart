import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/dashboard/group_dashboard/constants/group_dashboard_urls.dart';
import 'package:wallpost/dashboard/group_dashboard/services/group_dashboard_data_provider.dart';

import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var successfulResponse = Mocks.companiesListResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var companyListProvider = GroupDashboardDataProvider.initWith(mockNetworkAdapter);

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await companyListProvider.get();

    expect(mockNetworkAdapter.apiRequest.url, GroupDashboardUrls.getGroupDashboardUrl());
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
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await companyListProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var companyList = await companyListProvider.get();
    expect(companyList.groups.length, 2);
    expect(companyList.companies.length, 2);
    expect(companyList.companies[0].employee, isNotNull);
    expect(companyList.companies[0].financialSummary, isNotNull);
    expect(companyList.companies[1].employee, isNotNull);
    expect(companyList.companies[1].financialSummary, isNull);
  });
}
