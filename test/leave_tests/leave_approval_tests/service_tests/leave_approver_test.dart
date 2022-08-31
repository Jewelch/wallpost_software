import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/leave/leave_approval/constants/leave_approval_urls.dart';
import 'package:wallpost/leave/leave_approval/services/leave_approver.dart';

import '../../../_mocks/mock_network_adapter.dart';

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockNetworkAdapter = MockNetworkAdapter();
  var approver = LeaveApprover.initWith(mockNetworkAdapter);

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built and executed correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll({"app_type": "leaveRequest", "request_id": "someLeaveId"});
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve("someCompanyId", "someLeaveId");

    expect(mockNetworkAdapter.apiRequest.url, LeaveApprovalUrls.approveUrl("someCompanyId"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    expect(mockNetworkAdapter.didCallPost, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve("someCompanyId", "someLeaveId");
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await approver.approve("someCompanyId", "someLeaveId");
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    approver.approve("someCompanyId", "someLeaveId");

    expect(approver.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await approver.approve("someCompanyId", "someLeaveId");

    expect(approver.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await approver.approve("someCompanyId", "someLeaveId");
      fail('failed to throw exception');
    } catch (_) {
      expect(approver.isLoading, false);
    }
  });
}
