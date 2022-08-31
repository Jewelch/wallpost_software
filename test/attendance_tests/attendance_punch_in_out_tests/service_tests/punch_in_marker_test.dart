import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_urls.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/punch_in_marker.dart';

import '../../../_mocks/mock_network_adapter.dart';

class MockLocation extends Mock implements AttendanceLocation {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockLocation = MockLocation();
  var mockNetworkAdapter = MockNetworkAdapter();
  var punchInMarker = PunchInMarker.initWith(mockNetworkAdapter);

  setUpAll(() {
    when(() => mockLocation.toJson()).thenReturn({'location': 'info'});
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(mockLocation.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await punchInMarker.punchIn(mockLocation, isLocationValid: true);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceUrls.punchInUrl(true));
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
