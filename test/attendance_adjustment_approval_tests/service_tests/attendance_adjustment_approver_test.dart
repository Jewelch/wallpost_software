import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';
import 'package:wallpost/attendance_adjustment_approval/services/attendance_adjustment_approver.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceAdjustmentApproval extends Mock implements AttendanceAdjustmentApproval {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var approval = MockAttendanceAdjustmentApproval();
  var mockNetworkAdapter = MockNetworkAdapter();
  var approver = AttendanceAdjustmentApprover.initWith(mockNetworkAdapter);

  setUpAll(() {
    when(() => approval.id).thenReturn("someApprovalId");
    when(() => approval.companyId).thenReturn("someCompanyId");
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll({"app_type": "attendanceAdjustmentRequest", "request_id": "someApprovalId"});
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve(approval);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceAdjustmentApprovalUrls.approveUrl("someCompanyId"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve(approval);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await approver.approve(approval);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    approver.approve(approval);

    expect(approver.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve(approval);

    expect(approver.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve(approval);
      fail('failed to throw exception');
    } catch (_) {
      expect(approver.isLoading, false);
    }
  });
}
