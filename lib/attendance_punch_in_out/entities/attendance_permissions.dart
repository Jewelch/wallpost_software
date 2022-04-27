import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class AttendancePermissions extends JSONInitializable {
  late bool _canPunchInFromApp;
  late bool _canPunchInNow;
  late num _secondsTillPunchIn;

  AttendancePermissions.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _canPunchInFromApp = sift.readBooleanFromMap(jsonMap, 'punch_in_allowed_from_app');
      _canPunchInNow = sift.readBooleanFromMap(jsonMap, 'status');
      _secondsTillPunchIn = sift.readNumberFromMapWithDefaultValue(jsonMap, 'remaining_in_min', 0)!;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast PunchInNowPermission response. Error message - ${e.errorMessage}');
    }
  }

  bool get canPunchInFromApp => _canPunchInFromApp;

  bool get canPunchInNow => _canPunchInNow;

  num get secondsTillPunchIn => _secondsTillPunchIn;
}
