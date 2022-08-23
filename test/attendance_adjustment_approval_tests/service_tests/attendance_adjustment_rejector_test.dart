import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_rejector.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceAdjustmentApproval extends Mock implements AttendanceAdjustmentApproval {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var approval = MockAttendanceAdjustmentApproval();
  var mockNetworkAdapter = MockNetworkAdapter();
  var rejector = AttendanceAdjustmentRejector.initWith(mockNetworkAdapter);

  setUpAll(() {
    when(() => approval.id).thenReturn("someApprovalId");
    when(() => approval.companyId).thenReturn("someCompanyId");
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll({
      "app_type": "attendanceAdjustmentRequest",
      "request_id": "someApprovalId",
      "reason": "some reason",
    });
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await rejector.reject(approval, rejectionReason: "some reason");

    expect(mockNetworkAdapter.apiRequest.url, AttendanceAdjustmentApprovalUrls.rejectUrl("someCompanyId"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await rejector.reject(approval, rejectionReason: "some reason");
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await rejector.reject(approval, rejectionReason: "some reason");
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    rejector.reject(approval, rejectionReason: "some reason");

    expect(rejector.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await rejector.reject(approval, rejectionReason: "some reason");

    expect(rejector.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await rejector.reject(approval, rejectionReason: "some reason");
      fail('failed to throw exception');
    } catch (_) {
      expect(rejector.isLoading, false);
    }
  });
}
