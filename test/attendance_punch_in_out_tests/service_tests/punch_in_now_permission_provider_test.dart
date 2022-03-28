import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_in_now_permission_provider.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.punchInNowPermissionResponse;
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var punchInNowPermissionProvider = PunchInNowPermissionProvider.initWith(
    mockEmployeeProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchInNowPermissionProvider.canPunchInNow();

    expect(
        mockNetworkAdapter.apiRequest.url, AttendanceUrls.punchInNowPermissionProviderUrl('someCompanyId', 'v1EmpId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await punchInNowPermissionProvider.canPunchInNow();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    punchInNowPermissionProvider.canPunchInNow().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    punchInNowPermissionProvider.canPunchInNow().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await punchInNowPermissionProvider.canPunchInNow();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await punchInNowPermissionProvider.canPunchInNow();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await punchInNowPermissionProvider.canPunchInNow();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var punchInNowPermission = await punchInNowPermissionProvider.canPunchInNow();
      expect(punchInNowPermission, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    punchInNowPermissionProvider.canPunchInNow();

    expect(punchInNowPermissionProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchInNowPermissionProvider.canPunchInNow();

    expect(punchInNowPermissionProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await punchInNowPermissionProvider.canPunchInNow();
      fail('failed to throw exception');
    } catch (_) {
      expect(punchInNowPermissionProvider.isLoading, false);
    }
  });
}
