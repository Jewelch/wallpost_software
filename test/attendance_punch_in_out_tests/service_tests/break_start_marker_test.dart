import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/services/break_start_marker.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockLocation extends Mock implements AttendanceLocation {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockAttendanceDetails = MockAttendanceDetails();
  var mockLocation = MockLocation();
  var mockNetworkAdapter = MockNetworkAdapter();
  var breakStartMarker = BreakStartMarker.initWith(mockNetworkAdapter);

  setUp(() {
    mockNetworkAdapter.reset();
  });

  setUpAll(() {
    when(() => mockAttendanceDetails.attendanceDetailsId).thenReturn('someAttendanceDetailsId');
    when(() => mockLocation.toJson()).thenReturn({'location': 'info'});
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(mockLocation.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await breakStartMarker.startBreak(mockAttendanceDetails, mockLocation);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceUrls.breakStartUrl('someAttendanceDetailsId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await breakStartMarker.startBreak(mockAttendanceDetails, mockLocation);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 200);
    breakStartMarker.startBreak(mockAttendanceDetails, mockLocation).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    breakStartMarker.startBreak(mockAttendanceDetails, mockLocation).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await breakStartMarker.startBreak(mockAttendanceDetails, mockLocation);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    breakStartMarker.startBreak(mockAttendanceDetails, mockLocation);

    expect(breakStartMarker.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await breakStartMarker.startBreak(mockAttendanceDetails, mockLocation);

    expect(breakStartMarker.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await breakStartMarker.startBreak(mockAttendanceDetails, mockLocation);
      fail('failed to throw exception');
    } catch (_) {
      expect(breakStartMarker.isLoading, false);
    }
  });
}
