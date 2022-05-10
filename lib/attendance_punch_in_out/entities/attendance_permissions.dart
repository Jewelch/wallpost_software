import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class AttendancePermissions extends JSONInitializable {
  late bool _canMarkAttendancePermissionFromApp;
  late bool _canMarkAttendanceNow;
  late num _secondsTillPunchIn;

  AttendancePermissions.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _canMarkAttendancePermissionFromApp = sift.readBooleanFromMap(jsonMap, 'punch_in_allowed_from_app');
      _canMarkAttendanceNow = sift.readBooleanFromMap(jsonMap, 'status');
      _secondsTillPunchIn = sift.readNumberFromMapWithDefaultValue(jsonMap, 'remaining_in_min', 0)!;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast PunchInNowPermission response. Error message - ${e.errorMessage}');
    }
  }

  bool get canMarkAttendancePermissionFromApp => _canMarkAttendancePermissionFromApp;

  bool get canMarkAttendanceNow => _canMarkAttendanceNow;

  num get secondsTillPunchIn => _secondsTillPunchIn;
}
