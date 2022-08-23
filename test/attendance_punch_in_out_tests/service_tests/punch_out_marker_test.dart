import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_out_marker.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockLocation extends Mock implements AttendanceLocation {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockAttendanceDetails = MockAttendanceDetails();
  var mockLocation = MockLocation();
  var mockNetworkAdapter = MockNetworkAdapter();
  var punchOutMarker = PunchOutMarker.initWith(mockNetworkAdapter);

  setUpAll(() {
    when(() => mockAttendanceDetails.attendanceId).thenReturn('someAttendanceId');
    when(() => mockLocation.toJson()).thenReturn({'location': 'info'});
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(mockLocation.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchOutMarker.punchOut(mockAttendanceDetails, mockLocation, isLocationValid: true);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceUrls.punchOutUrl('someAttendanceId', true));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPut, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await punchOutMarker.punchOut(mockAttendanceDetails, mockLocation, isLocationValid: true);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await punchOutMarker.punchOut(mockAttendanceDetails, mockLocation, isLocationValid: true);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    punchOutMarker.punchOut(mockAttendanceDetails, mockLocation, isLocationValid: true);

    expect(punchOutMarker.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchOutMarker.punchOut(mockAttendanceDetails, mockLocation, isLocationValid: true);

    expect(punchOutMarker.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await punchOutMarker.punchOut(mockAttendanceDetails, mockLocation, isLocationValid: true);
      fail('failed to throw exception');
    } catch (_) {
      expect(punchOutMarker.isLoading, false);
    }
  });
}
