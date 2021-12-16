// @dart=2.9

import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class LeaveAirport extends JSONInitializable {
  num _id;
  String _name;

  LeaveAirport.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = sift.readNumberFromMap(jsonMap, 'id');
      _name = sift.readStringFromMap(jsonMap, 'airport');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveAirport response. Error message - ${e.errorMessage}');
    }
  }

  num get id => _id;

  String get name => _name;
}
