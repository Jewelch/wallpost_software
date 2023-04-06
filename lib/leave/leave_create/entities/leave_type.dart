import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class LeaveType extends JSONInitializable {
  late String _code;
  late String _id;
  late String _name;
  late num _requiredMinimumPeriod;
  late bool _requiresCertificate;

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
