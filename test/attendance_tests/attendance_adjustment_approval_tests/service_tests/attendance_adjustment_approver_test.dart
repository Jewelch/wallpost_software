import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/constants/attendance_adjustment_approval_urls.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/services/attendance_adjustment_approver.dart';

import '../../../_mocks/mock_network_adapter.dart';

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockNetworkAdapter = MockNetworkAdapter();
  var approver = AttendanceAdjustmentApprover.initWith(mockNetworkAdapter);

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll({"app_type": "attendanceAdjustmentRequest", "request_id": "someApprovalId"});
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve("someCompanyId", "someApprovalId");

    expect(mockNetworkAdapter.apiRequest.url, AttendanceAdjustmentApprovalUrls.approveUrl("someCompanyId"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve("someCompanyId", "someApprovalId");
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await approver.approve("someCompanyId", "someApprovalId");
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    approver.approve("someCompanyId", "someApprovalId");

    expect(approver.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve("someCompanyId", "someApprovalId");

    expect(approver.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve("someCompanyId", "someApprovalId");
      fail('failed to throw exception');
    } catch (_) {
      expect(approver.isLoading, false);
    }
  });
}
