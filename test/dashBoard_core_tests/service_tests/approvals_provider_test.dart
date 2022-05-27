import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/dashboard_core/constants/dashboard_management_urls.dart';
import 'package:wallpost/dashboard_core/services/approvals_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../dashBoard_core_tests/mocks.dart';
import '../../expense_requests_tests/services_tests/expense_request_executer_test.dart';

class MockPortalActionAlertProvider extends Mock {}

class MockCompany extends Mock implements Company {}


void main() {
  var successfulResponse = Mocks.approvalsResponse;
  var successfulMetaDataResponse = Mocks.approvalsMetaDataResponse;


  var mockNetworkAdapter = MockNetworkAdapter();
  var mockSelectedCompany = MockSelectedCompanyProvider();
  late SelectedCompanyApprovalsListProvider portalActionProvider;

  setUpAll(() {
    portalActionProvider = SelectedCompanyApprovalsListProvider.initWith(mockNetworkAdapter, mockSelectedCompany);
  });

  setUp(() {
     reset(mockSelectedCompany);
  });

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(mockSelectedCompany);
  }


  test('api request is built correctly', () async {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockSelectedCompany.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse,metaData: successfulMetaDataResponse);

    var _ = await portalActionProvider.getNext();

    expect(mockNetworkAdapter.apiRequest.url, DashboardManagementUrls.getCompanyApprovals("15", 1, 30));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockSelectedCompany.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await portalActionProvider.getNext();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockSelectedCompany.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await portalActionProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test(
      'throws WrongResponseFormatException when response is of the wrong format', () async {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockSelectedCompany.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await portalActionProvider.getNext();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockSelectedCompany.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await portalActionProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockSelectedCompany.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await portalActionProvider.getNext();
      verifyInOrder([
        () => mockSelectedCompany.getSelectedCompanyForCurrentUser(),
      ]);
      _verifyNoMoreInteractions();
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
