import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import 'attendance_adjustment_submitter_test.dart';

void main() {
  String successfulResponse = "attendanceStatus";
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockEmployee = MockEmployee();
  var adjustedAttendanceStatusProvider =
      AdjustedAttendanceStatusProvider.initWith(mockEmployeeProvider, mockNetworkAdapter);
  var mockAttendanceAdjustmentForm = MockAttendanceAdjustmentForm();

  setUpAll(() {
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockAttendanceAdjustmentForm.date).thenReturn('date');
    when(() => mockAttendanceAdjustmentForm.adjustedPunchInTime).thenReturn('09:00');
    when(() => mockAttendanceAdjustmentForm.adjustedPunchOutTime).thenReturn('06:00');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await adjustedAttendanceStatusProvider.getAdjustedStatus(mockAttendanceAdjustmentForm);

    expect(mockNetworkAdapter.apiRequest.url,
        AttendanceAdjustmentUrls.getAdjustedStatusUrl('someCompanyId', 'v1EmpId', 'date', '09:00', '06:00'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    adjustedAttendanceStatusProvider.getAdjustedStatus(mockAttendanceAdjustmentForm);

    expect(adjustedAttendanceStatusProvider.isLoading, true);
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    adjustedAttendanceStatusProvider.getAdjustedStatus(mockAttendanceAdjustmentForm).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    adjustedAttendanceStatusProvider.getAdjustedStatus(mockAttendanceAdjustmentForm).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await adjustedAttendanceStatusProvider.getAdjustedStatus(mockAttendanceAdjustmentForm);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await adjustedAttendanceStatusProvider.getAdjustedStatus(mockAttendanceAdjustmentForm);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });
}
