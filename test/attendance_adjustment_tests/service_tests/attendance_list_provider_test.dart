import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.attendanceListResponse;
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockEmployee = MockEmployee();
  var attendanceListsProvider = AttendanceListsProvider.initWith(
      mockEmployeeProvider, mockNetworkAdapter);
  var month = DateTime.now().month;
  var year = DateTime.now().year;

  setUpAll(() {
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser())
        .thenReturn(mockEmployee);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceListsProvider.get();

    expect(
        mockNetworkAdapter.apiRequest.url,
        AttendanceAdjustmentUrls.getAttendanceListsUrl(
            'someCompanyId', 'v1EmpId', month, year));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('test loading flag is set to true when the service is executed',
      () {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceListsProvider.get();

    expect(attendanceListsProvider.isLoading, true);
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    attendanceListsProvider.get().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    attendanceListsProvider.get().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await attendanceListsProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test(
      'throws WrongResponseFormatException when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await attendanceListsProvider.get();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
   });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await attendanceListsProvider.get();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });
}
