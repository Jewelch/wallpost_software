import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class TaskCategory extends JSONInitializable {
  String _id;
  String _name;
  String _description;

  TaskCategory.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = sift.readStringFromMap(jsonMap, 'category_id');
      _name = sift.readStringFromMap(jsonMap, 'name');
      _description = sift.readStringFromMap(jsonMap, 'description');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast TaskCategory response. Error message - ${e.errorMessage}');
    }
  }

  String get id => _id;

  String get name => _name;

  String get description => _description;
}
