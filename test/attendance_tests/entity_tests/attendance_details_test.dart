// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';

import '../mocks.dart';

void main() {
  test('getting time strings', () async {
    var attendanceDetails = AttendanceDetails.fromJson(Mocks.punchedOutAttendanceDetailsResponse);

    expect(attendanceDetails.attendanceId, 'someAttendanceId');
    expect(attendanceDetails.attendanceDetailsId, 'someAttendanceDetailsId');
    expect(attendanceDetails.punchInTimeString, '08:00 AM');
    expect(attendanceDetails.punchOutTimeString, '05:00 PM');
    expect(attendanceDetails.activeBreakStartTimeString, '01:00 PM');
  });

  test('getting active break id', () async {
    var attendanceDetails = AttendanceDetails.fromJson(Mocks.punchedInAttendanceWithActiveBreakResponse);

    expect(attendanceDetails.activeBreakId, 'someBreakId');
  });

  test('different stages of attendance', () async {
    var attendanceDetails = AttendanceDetails.fromJson(Mocks.noAttendanceResponse);
    expect(attendanceDetails.isPunchedIn, false);
    expect(attendanceDetails.isOnBreak, false);

    attendanceDetails = AttendanceDetails.fromJson(Mocks.punchedInAttendanceResponse);
    expect(attendanceDetails.isPunchedIn, true);
    expect(attendanceDetails.isOnBreak, false);

    attendanceDetails = AttendanceDetails.fromJson(Mocks.punchedInAttendanceWithActiveBreakResponse);
    expect(attendanceDetails.isPunchedIn, true);
    expect(attendanceDetails.isOnBreak, true);

    attendanceDetails = AttendanceDetails.fromJson(Mocks.punchedOutAttendanceDetailsResponse);
    expect(attendanceDetails.isPunchedIn, false);
    expect(attendanceDetails.isOnBreak, false);
  });
}
