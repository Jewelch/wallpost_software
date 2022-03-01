import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';


//TODO - delete this class
class Identifier extends JSONInitializable {
  late String id;
  late String name;

  Identifier.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      id = sift.readNumberFromMap(jsonMap, 'id').toString();
      name = sift.readStringFromMap(jsonMap, 'name');
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast identifier response. Error message - ${e.errorMessage}');
    }
  }
}
