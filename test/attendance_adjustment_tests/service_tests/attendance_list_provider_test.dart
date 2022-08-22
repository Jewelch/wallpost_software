import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';

import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../../expense_list_tests/services_tests/expense_list_provider_test.dart';
import '../mocks.dart';

void main() {
  Map<String, dynamic> successfulResponse = Mocks.attendanceListResponse;
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var mockEmployee = MockEmployee();
  var attendanceListProvider = AttendanceListProvider.initWith(mockCompanyProvider, mockNetworkAdapter);
  var month = DateTime.now().month;
  var year = DateTime.now().year;

  setUpAll(() {
    var company = MockCompany();
    when(() => company.id).thenReturn('someCompanyId');
    when(() => company.employee).thenReturn(mockEmployee);
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceListProvider.get(month, year);

    expect(mockNetworkAdapter.apiRequest.url,
        AttendanceAdjustmentUrls.getAttendanceListsUrl('someCompanyId', 'v1EmpId', month, year));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    attendanceListProvider.get(month, year).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    attendanceListProvider.get(month, year).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await attendanceListProvider.get(month, year);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await attendanceListProvider.get(month, year);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await attendanceListProvider.get(month, year);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var attendanceList = await attendanceListProvider.get(month, year);
      expect(attendanceList.length, 5);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('removed todays attendance is not punched out', () async {
    var responseWithTodaysAttendance = {
      "data": [
        {
          "id": "401",
          "company_id": 15,
          "attendance_id": "mua8lqhCQE6SyIz",
          "date": "2022-01-28",
          "adjusted_status": "PRESENT",
          "punch_in_time": "09:00",
          "punch_out_time": "06:00",
          "orig_punch_in_time": null,
          "orig_punch_out_time": null,
          "reason": "forgot to punch",
          "approval_status": "Pending",
          "approver_name": "Jayden Mathew"
        },
        {
          "id": "500",
          "company_id": 15,
          "attendance_id": "GAlgrqH5NsHqLaH",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "adjusted_status": "EARLYLEAVE",
          "punch_in_time": "11:00",
          "punch_out_time": null,
          "orig_punch_in_time": null,
          "orig_punch_out_time": null,
          "reason": "llllll",
          "approval_status": "Pending",
          "approver_name": "Jayden Mathew"
        },
      ],
    };
    mockNetworkAdapter.succeed(responseWithTodaysAttendance);

    try {
      var attendanceList = await attendanceListProvider.get(month, year);
      expect(attendanceList.length, 1);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceListProvider.get(month, year);

    expect(attendanceListProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await attendanceListProvider.get(month, year);

    expect(attendanceListProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await attendanceListProvider.get(month, year);
      fail('failed to throw exception');
    } catch (_) {
      expect(attendanceListProvider.isLoading, false);
    }
  });
}
