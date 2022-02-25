import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';

import '../mocks.dart';

void main() {
  test('different types of statuses', () async {
    var attendanceListItem1 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse1);
    expect(attendanceListItem1.status, AttendanceStatus.Present);

    var attendanceListItem2 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse2);
    expect(attendanceListItem2.status, AttendanceStatus.EarlyLeave);

    var attendanceListItem3 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse3);
    expect(attendanceListItem3.status, AttendanceStatus.Absent);

    var attendanceListItem4 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse4);
    expect(attendanceListItem4.status, AttendanceStatus.Late);

    var attendanceListItem5 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse5);
    expect(attendanceListItem5.status, AttendanceStatus.HalfDay);

    var attendanceListItem6 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse6);
    expect(attendanceListItem6.status, AttendanceStatus.NoAction);

    var attendanceListItem7 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse7);
    expect(attendanceListItem7.status, AttendanceStatus.Break);

    var attendanceListItem8 = AttendanceListItem.fromJson(Mocks.attendanceListItemResponse8);
    expect(attendanceListItem8.status, AttendanceStatus.OnTime);
  });
}
