import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import '../mocks.dart';

void main() {
  test('getting values', () async {
    var attendanceListItem = AttendanceListItem.fromJSon(Mocks.attendanceListItemResponse);

    expect(attendanceListItem.status,'PRESENT');
    expect(attendanceListItem.punchInTime , '09:00' );
    expect(attendanceListItem.punchOutTime , '06:00' );
    expect(attendanceListItem.date , '2022-01-28' );

  });
}