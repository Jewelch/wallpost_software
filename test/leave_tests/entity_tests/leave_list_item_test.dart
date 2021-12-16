// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';
import 'package:wallpost/leave/entities/leave_status.dart';

import '../mocks.dart';

void main() {
  test('pending status test', () async {
    var leaveListItemJson = Mocks.leaveListResponse[0];
    leaveListItemJson["status"] = 0;

    var leaveListItem = LeaveListItem.fromJson(leaveListItemJson);

    expect(leaveListItem.status, LeaveStatus.pendingApproval);
  });

  test('approved status test', () async {
    var leaveListItemJson = Mocks.leaveListResponse[0];
    leaveListItemJson["status"] = 1;

    var leaveListItem = LeaveListItem.fromJson(leaveListItemJson);

    expect(leaveListItem.status, LeaveStatus.approved);
  });

  test('rejected status ', () async {
    var leaveListItemJson = Mocks.leaveListResponse[0];
    leaveListItemJson["status"] = 2;

    var leaveListItem = LeaveListItem.fromJson(leaveListItemJson);

    expect(leaveListItem.status, LeaveStatus.rejected);
  });

  test('cancelled status', () async {
    var leaveListItemJson = Mocks.leaveListResponse[0];
    leaveListItemJson["status"] = 3;

    var leaveListItem = LeaveListItem.fromJson(leaveListItemJson);

    expect(leaveListItem.status, LeaveStatus.cancelled);
  });
}
