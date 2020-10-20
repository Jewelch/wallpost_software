import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';

import '../mocks.dart';

void main() {
  test('getting the time remaining till punch in as string', () async {
    PunchInNowPermission permission;
    var punchInNowPermissionResponse = Mocks.punchInNowPermissionResponse;

    punchInNowPermissionResponse['remaining_in_min'] = 4890;
    permission = PunchInNowPermission.fromJson(punchInNowPermissionResponse);
    expect(permission.timeTillPunchIn, '1h 21m 30s');

    punchInNowPermissionResponse['remaining_in_min'] = 30193;
    permission = PunchInNowPermission.fromJson(punchInNowPermissionResponse);
    expect(permission.timeTillPunchIn, '8h 23m 13s');

    punchInNowPermissionResponse['remaining_in_min'] = 198720;
    permission = PunchInNowPermission.fromJson(punchInNowPermissionResponse);
    expect(permission.timeTillPunchIn, '2 days');
  });
}
