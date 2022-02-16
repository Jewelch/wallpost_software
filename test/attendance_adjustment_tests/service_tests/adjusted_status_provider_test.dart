import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

class MockAdjustedStatusForm extends Mock implements AdjustedStatusForm {}

void main() {
  String successfulResponse = 'present';
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockEmployee = MockEmployee();
  var adjustedAttendanceStatusProvider =
      AdjustedStatusProvider.initWith(mockEmployeeProvider, mockNetworkAdapter);
  var mockAdjustedStatusForm = MockAdjustedStatusForm();
  DateTime date = DateTime(22, 01, 2021);
  DateTime adjustedPunchInTime = DateFormat('hh:mm').parse("09:00");
  DateTime adjustedPunchOutTime = DateFormat('hh:mm').parse("06:00");

  setUpAll(() {
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockAdjustedStatusForm.date).thenReturn(date);
    when(() => mockAdjustedStatusForm.adjustedPunchInTime).thenReturn(adjustedPunchInTime);
    when(() => mockAdjustedStatusForm.adjustedPunchOutTime).thenReturn(adjustedPunchOutTime);
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await adjustedAttendanceStatusProvider.getAdjustedStatus(mockAdjustedStatusForm);

    expect(
        mockNetworkAdapter.apiRequest.url,
        AttendanceAdjustmentUrls.getAdjustedStatusUrl(
            'someCompanyId', 'v1EmpId', date, adjustedPunchInTime, adjustedPunchOutTime));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    adjustedAttendanceStatusProvider.getAdjustedStatus(mockAdjustedStatusForm);

    expect(adjustedAttendanceStatusProvider.isLoading, true);
   });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    adjustedAttendanceStatusProvider.getAdjustedStatus(mockAdjustedStatusForm).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    adjustedAttendanceStatusProvider.getAdjustedStatus(mockAdjustedStatusForm).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await adjustedAttendanceStatusProvider.getAdjustedStatus(mockAdjustedStatusForm);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await adjustedAttendanceStatusProvider.getAdjustedStatus(mockAdjustedStatusForm);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });
}
