import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import '../mocks.dart';

void main() {
  test('getting values', () async {
    var attendanceListItem = AttendanceListItem.fromJSon(Mocks.attendanceListItemResponse);

    expect(attendanceListItem.adjustedStatus,'PRESENT');
    // expect(attendanceListItem.punchInTime , '08:47' );
    // expect(attendanceListItem.punchOutTime , '18:00' );
    expect(attendanceListItem.date , '2022-01-28' );
    expect(attendanceListItem.attendanceID , 'Q8pyUr23o8kuGJw' );
    expect(attendanceListItem.reason , null );
    expect(attendanceListItem.approvalStatus , 'null' );
    expect(attendanceListItem.approverName , 'null' );

  });
}
