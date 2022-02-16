import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class ExpenseCategory extends JSONInitializable {
  late final String id;
  late final String name;
  late final List<ExpenseCategory> subCategories;
  late final List<String> projects;

  ExpenseCategory.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      id = sift.readNumberFromMap(jsonMap, 'id').toString();
      name = sift.readStringFromMap(jsonMap, 'name');
      subCategories = sift
          .readMapListFromMap(jsonMap, 'sub_categories')
          .map((e) => ExpenseCategory.fromJson(e))
          .toList();
      projects = sift.readStringListFromMap(jsonMap, 'projects');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Company response. Error message - ${e.errorMessage}');
    }
  }
}
