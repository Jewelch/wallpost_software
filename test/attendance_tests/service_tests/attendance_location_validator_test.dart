import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/constants/attendance_urls.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/services/attendance_location_validator.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

void main() {
  var attendanceLocation = AttendanceLocation(12.34, 35.12);
  Map<String, dynamic> successfulResponse = {};
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var attendanceLocationValidator = AttendanceLocationValidator.initWith(
    mockEmployeeProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(attendanceLocation.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);

    expect(mockNetworkAdapter.apiRequest.url,
        AttendanceUrls.attendanceLocationValidationUrl('someCompanyId', 'v1EmpId', true));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('returns false in case of serve sent exception', () async {
    mockNetworkAdapter.fail(ServerSentException('some error message', 12));

    try {
      var isValid = await attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);
      expect(isValid, false);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var isValid = await attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);
      expect(isValid, true);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);

    expect(attendanceLocationValidator.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);

    expect(attendanceLocationValidator.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceLocationValidator.validateLocation(attendanceLocation, isForPunchIn: true);
      fail('failed to throw exception');
    } catch (_) {
      expect(attendanceLocationValidator.isLoading, false);
    }
  });
}
