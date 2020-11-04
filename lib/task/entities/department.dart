import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class Department extends JSONInitializable {
  num _id;
  String _name;
  String _description;

  Department.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = sift.readNumberFromMap(jsonMap, 'id');
      _name = sift.readStringFromMap(jsonMap, 'name');
      _description = sift.readStringFromMap(jsonMap, 'description');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Department response. Error message - ${e.errorMessage}');
    }
  }

  num get id => _id;

  String get name => _name;

  String get description => _description;
}
