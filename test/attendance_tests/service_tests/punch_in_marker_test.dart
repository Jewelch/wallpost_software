import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/constants/attendance_urls.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/services/punch_in_marker.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

class MockLocation extends Mock implements AttendanceLocation {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockLocation = MockLocation();
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var punchInMarker = PunchInMarker.initWith(mockEmployeeProvider, mockNetworkAdapter);

  setUpAll(() {
    when(() => mockLocation.toJson()).thenReturn({'location': 'info'});
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(mockLocation.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchInMarker.punchIn(mockLocation, isLocationValid: true);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceUrls.punchInUrl('someCompanyId', 'v1EmpId', true));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await punchInMarker.punchIn(mockLocation, isLocationValid: true);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('does nothing when a subsequent call is made and the service is running', () async {
    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 50);

    punchInMarker.punchIn(mockLocation, isLocationValid: true);
    punchInMarker.punchIn(mockLocation, isLocationValid: true);

    await Future.delayed(Duration(milliseconds: 100));
    expect(mockNetworkAdapter.noOfTimesPostIsCalled, 1);
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await punchInMarker.punchIn(mockLocation, isLocationValid: true);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    punchInMarker.punchIn(mockLocation, isLocationValid: true);

    expect(punchInMarker.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchInMarker.punchIn(mockLocation, isLocationValid: true);

    expect(punchInMarker.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await punchInMarker.punchIn(mockLocation, isLocationValid: true);
      fail('failed to throw exception');
    } catch (_) {
      expect(punchInMarker.isLoading, false);
    }
  });
}
