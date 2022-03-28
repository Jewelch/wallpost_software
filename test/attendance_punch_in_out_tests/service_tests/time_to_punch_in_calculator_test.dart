import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance_punch_in_out/services/time_to_punch_in_calculator.dart';

void main() {
  test('getting the time remaining till punch in as string', () async {
    expect(TimeToPunchInCalculator.timeTillPunchIn(4890), '1h 21m 30s');

    expect(TimeToPunchInCalculator.timeTillPunchIn(30193), '8h 23m 13s');

    expect(TimeToPunchInCalculator.timeTillPunchIn(198720), '2 days');
  });
}
