import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/services/break_end_marker.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockLocation extends Mock implements AttendanceLocation {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockAttendanceDetails = MockAttendanceDetails();
  var mockLocation = MockLocation();
  var mockNetworkAdapter = MockNetworkAdapter();
  var breakEndMarker = BreakEndMarker.initWith(mockNetworkAdapter);

  setUp(() {
    mockNetworkAdapter.reset();
    when(() => mockAttendanceDetails.activeBreakId).thenReturn('someBreakId');
  });

  setUpAll(() {
    when(() => mockAttendanceDetails.attendanceDetailsId).thenReturn('someAttendanceDetailsId');
    when(() => mockLocation.toJson()).thenReturn({'location': 'info'});
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(mockLocation.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceUrls.breakEndUrl('someAttendanceDetailsId', 'someBreakId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPut, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(successfulResponse, afterDelayInMilliSeconds: 500);
    breakEndMarker.endBreak(mockAttendanceDetails, mockLocation).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(successfulResponse);
    breakEndMarker.endBreak(mockAttendanceDetails, mockLocation).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('does nothing when there is no active break', () async {
    mockNetworkAdapter.reset();
    mockNetworkAdapter.succeed(successfulResponse);
    when(() => mockAttendanceDetails.activeBreakId).thenReturn(null);

    var _ = await breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);

    expect(mockNetworkAdapter.didCallPut, false);
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);

    expect(breakEndMarker.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);

    expect(breakEndMarker.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await breakEndMarker.endBreak(mockAttendanceDetails, mockLocation);
      fail('failed to throw exception');
    } catch (_) {
      expect(breakEndMarker.isLoading, false);
    }
  });
}
