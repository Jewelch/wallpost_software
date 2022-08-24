import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class ExpenseCategory extends JSONInitializable {
  late final String id;
  late final String name;
  late final List<ExpenseCategory> subCategories;
  late final List<ExpenseCategory> projects;
  late final bool isDisabled;

  ExpenseCategory.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      id = sift.readNumberFromMap(jsonMap, 'id').toString();
      name = sift.readStringFromMap(jsonMap, 'name');
      subCategories = _readSubCategories(jsonMap);
      projects = _readProjects(jsonMap);
      isDisabled = sift.readBooleanFromMap(jsonMap, "disabled");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast expense category response. Error message - ${e.errorMessage}');
    }
  }

  List<ExpenseCategory> _readSubCategories(Map<String, dynamic> jsonMap) {
    return Sift()
        .readMapListFromMapWithDefaultValue(jsonMap, 'subCatagories', [])!
        .map((subCategoryMap) => ExpenseCategory.fromJson(subCategoryMap))
        .toList();
  }

  List<ExpenseCategory> _readProjects(Map<String, dynamic> jsonMap) {
    return Sift()
        .readMapListFromMapWithDefaultValue(jsonMap, 'projects', [])!
        .map((projectMap) => ExpenseCategory.fromJson(projectMap))
        .toList();
  }
}
