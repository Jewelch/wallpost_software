// @dart=2.9

import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class LeaveType extends JSONInitializable {
  String _code;
  String _id;
  String _name;
  num _requiredMinimumPeriod;
  bool _requiresCertificate;

  LeaveType.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _code = sift.readStringFromMap(jsonMap, 'code');
      _id = '${sift.readNumberFromMap(jsonMap, 'id')}';
      _name = sift.readStringFromMap(jsonMap, 'name');
      _requiredMinimumPeriod = sift.readNumberFromMap(jsonMap, 'min_period');
      _requiresCertificate = sift.readStringFromMap(jsonMap, 'requires_certificate') == '1';
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveType response. Error message - ${e.errorMessage}');
    }
  }

  String get code => _code;

  String get id => _id;

  String get name => _name;

  num get requiredMinimumPeriod => _requiredMinimumPeriod;

  bool get requiresCertificate => _requiresCertificate;
}
