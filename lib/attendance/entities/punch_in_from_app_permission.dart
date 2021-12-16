// @dart=2.9

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class PunchInFromAppPermission extends JSONInitializable {
  bool _isAllowed;

  PunchInFromAppPermission.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _isAllowed = sift.readBooleanFromMap(jsonMap, 'punch_in_allowed');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast PunchInFromAppPermission response. Error message - ${e.errorMessage}');
    }
  }

  bool get isAllowed => _isAllowed;
}
