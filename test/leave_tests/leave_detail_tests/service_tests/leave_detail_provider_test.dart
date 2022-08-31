import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/leave/leave_detail/constants/leave_detail_urls.dart';
import 'package:wallpost/leave/leave_detail/services/leave_detail_provider.dart';

import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.leaveDetailResponse;
  var mockNetworkAdapter = MockNetworkAdapter();
  var detailsProvider = LeaveDetailProvider.initWith("someCompanyId", mockNetworkAdapter);

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await detailsProvider.get("someLeaveId");

    expect(mockNetworkAdapter.apiRequest.url, LeaveDetailUrls.leaveDetailUrl("someCompanyId", "someLeaveId"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await detailsProvider.get("someLeaveId");
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    detailsProvider.get("someLeaveId").then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    detailsProvider.get("someLeaveId").then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await detailsProvider.get("someLeaveId");
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await detailsProvider.get("someLeaveId");
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when response mapping fails', () async {
    mockNetworkAdapter.succeed(Map<String, dynamic>());

    try {
      var _ = await detailsProvider.get("someLeaveId");
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var detail = await detailsProvider.get("someLeaveId");
      expect(detail, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    detailsProvider.get("someLeaveId");

    expect(detailsProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await detailsProvider.get("someLeaveId");

    expect(detailsProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await detailsProvider.get("someLeaveId");
      fail('failed to throw exception');
    } catch (_) {
      expect(detailsProvider.isLoading, false);
    }
  });
}
