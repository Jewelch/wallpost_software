import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/leave/leave_detail/entities/leave_detail.dart';

import '../mocks.dart';

void main() {
  test("status", () {
    var response = Mocks.leaveDetailResponse;

    response["status"] = 0;
    var leaveDetail = LeaveDetail.fromJson(response);
    expect(leaveDetail.isPendingApproval(), true);
    expect(leaveDetail.isApproved(), false);
    expect(leaveDetail.isRejected(), false);
    expect(leaveDetail.isCancelled(), false);

    response["status"] = 1;
    leaveDetail = LeaveDetail.fromJson(response);
    expect(leaveDetail.isApproved(), true);
    expect(leaveDetail.isPendingApproval(), false);
    expect(leaveDetail.isRejected(), false);
    expect(leaveDetail.isCancelled(), false);

    response["status"] = 2;
    leaveDetail = LeaveDetail.fromJson(response);
    expect(leaveDetail.isRejected(), true);
    expect(leaveDetail.isApproved(), false);
    expect(leaveDetail.isPendingApproval(), false);
    expect(leaveDetail.isCancelled(), false);

    response["status"] = 3;
    leaveDetail = LeaveDetail.fromJson(response);
    expect(leaveDetail.isCancelled(), true);
    expect(leaveDetail.isApproved(), false);
    expect(leaveDetail.isPendingApproval(), false);
    expect(leaveDetail.isRejected(), false);
  });
}
