import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/aggregated_approvals_list/entities/aggregated_approval.dart';

import '../mocks.dart';

void main() {
  test('isAttendanceAdjustmentApproval', () {
    var jsonMap = Mocks.aggregatedApprovalsResponse[0];
    jsonMap["approvalType"] = "Attendance Adjustment";

    var aggregatedApproval = AggregatedApproval.fromJson(jsonMap);

    expect(aggregatedApproval.isAttendanceAdjustmentApproval(), true);
    expect(aggregatedApproval.isExpenseRequestApproval(), false);
    expect(aggregatedApproval.isLeaveRequestApproval(), false);
  });

  test('isExpenseRequestApproval', () {
    var jsonMap = Mocks.aggregatedApprovalsResponse[0];
    jsonMap["approvalType"] = "Expense Request";

    var aggregatedApproval = AggregatedApproval.fromJson(jsonMap);

    expect(aggregatedApproval.isExpenseRequestApproval(), true);
    expect(aggregatedApproval.isAttendanceAdjustmentApproval(), false);
    expect(aggregatedApproval.isLeaveRequestApproval(), false);
  });

  test('isLeaveRequestApproval', () {
    var jsonMap = Mocks.aggregatedApprovalsResponse[0];
    jsonMap["approvalType"] = "Leave Request";

    var aggregatedApproval = AggregatedApproval.fromJson(jsonMap);

    expect(aggregatedApproval.isLeaveRequestApproval(), true);
    expect(aggregatedApproval.isAttendanceAdjustmentApproval(), false);
    expect(aggregatedApproval.isExpenseRequestApproval(), false);
  });

  test('setting approval count', () {
    var jsonMap = Mocks.aggregatedApprovalsResponse[0];
    jsonMap["approvalType"] = "Leave Request";
    var aggregatedApproval = AggregatedApproval.fromJson(jsonMap);

    aggregatedApproval.setCount(3);

    expect(aggregatedApproval.approvalCount, 3);
  });
}
