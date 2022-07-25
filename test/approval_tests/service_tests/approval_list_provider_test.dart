import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/approvals/services/approval_list_provider.dart';
import 'package:wallpost/dashboard_core/constants/dashboard_management_urls.dart';

import '../../_mocks/mock_network_adapter.dart';
import '../../expense_list_tests/services_tests/expense_list_provider_test.dart';
import '../mocks.dart';

class MockPortalActionAlertProvider extends Mock {}

void main() {
  var successfulResponse = Mocks.approvalsResponse;
  var successfulMetaDataResponse = Mocks.approvalsMetaDataResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockCompanyProvider = MockSelectedCompanyProvider();
  late ApprovalListProvider approvalListProvider;

  setUp(() {
    reset(mockCompanyProvider);

    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("15");
    when(mockCompanyProvider.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);

    approvalListProvider = ApprovalListProvider.initWith(mockNetworkAdapter, mockCompanyProvider);
  });

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(mockCompanyProvider);
  }

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse, metaData: successfulMetaDataResponse);

    var _ = await approvalListProvider.getNext();

    expect(mockNetworkAdapter.apiRequest.url, DashboardManagementUrls.getApprovalsUrl("15", 1, 15));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approvalListProvider.getNext();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    approvalListProvider.getNext().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    approvalListProvider.reset();

    mockNetworkAdapter.succeed(successfulResponse);
    approvalListProvider.getNext().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await approvalListProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await approvalListProvider.getNext();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await approvalListProvider.getNext();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse, metaData: successfulMetaDataResponse);

    try {
      var _ = await approvalListProvider.getNext();
      verifyInOrder([
        () => mockCompanyProvider.getSelectedCompanyForCurrentUser(),
      ]);
      _verifyNoMoreInteractions();
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('page number is updated after each call', () async {
    mockNetworkAdapter.succeed(successfulResponse);
    approvalListProvider.reset();
    try {
      expect(approvalListProvider.getCurrentPageNumber(), 1);
      await approvalListProvider.getNext();
      expect(approvalListProvider.getCurrentPageNumber(), 2);
      await approvalListProvider.getNext();
      expect(approvalListProvider.getCurrentPageNumber(), 3);
      await approvalListProvider.getNext();
      expect(approvalListProvider.getCurrentPageNumber(), 4);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    approvalListProvider.getNext();

    expect(approvalListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approvalListProvider.getNext();

    expect(approvalListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approvalListProvider.getNext();
      fail('failed to throw exception');
    } catch (_) {
      expect(approvalListProvider.isLoading, false);
    }
  });
}
