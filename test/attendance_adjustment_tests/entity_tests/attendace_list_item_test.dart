import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';

import '../mocks.dart';

void main() {
  test('is approval not pending', () {
    var map = Mocks.attendanceListResponse["data"][0];
    map["approval_status"] = null;

    var item = AttendanceListItem.fromJson(map);

    expect(item.isApprovalPending(), false);
  });

  test('is  approval pending', () {
    var map = Mocks.attendanceListResponse["data"][0];
    map["approval_status"] = "Pending";

    var item = AttendanceListItem.fromJson(map);

    expect(item.isApprovalPending(), true);
  });
}
