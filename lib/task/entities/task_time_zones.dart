// @dart=2.9

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class TaskTimeZones extends JSONInitializable {
  List<String> _timezones;

  TaskTimeZones.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _timezones = sift.readStringListFromMap(jsonMap, 'timezones');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast TaskTimeZones response. Error message - ${e.errorMessage}');
    }
  }

  List<String> get timezones => _timezones;
}
