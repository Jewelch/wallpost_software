import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/attendance/constants/attendance_urls.dart';
import 'package:wallpost/attendance/services/attendance_report_provider.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

void main() {
  List<Map<String, dynamic>> successfulResponse = Mocks.attendanceReportResponse;
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var attendanceReportProvider = AttendanceReportProvider.initWith(mockEmployeeProvider, mockNetworkAdapter);
  var startDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var endDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0));

  setUpAll(() {
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceReportProvider.getReport();

    expect(mockNetworkAdapter.apiRequest.url,
        AttendanceUrls.attendanceReportUrl('someCompanyId', 'v1EmpId', startDate, endDate));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceReportProvider.getReport();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);
    attendanceReportProvider.getReport().then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    attendanceReportProvider.getReport().then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await attendanceReportProvider.getReport();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await attendanceReportProvider.getReport();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await attendanceReportProvider.getReport();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var attendanceReport = await attendanceReportProvider.getReport();
      expect(attendanceReport, isNotNull);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceReportProvider.getReport();

    expect(attendanceReportProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceReportProvider.getReport();

    expect(attendanceReportProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceReportProvider.getReport();
      fail('failed to throw exception');
    } catch (_) {
      expect(attendanceReportProvider.isLoading, false);
    }
  });
}
