import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_wp_core/permission/entities/Role.dart';

class Permission implements JSONInitializable, JSONConvertible {
  late Roles role;

  Permission.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      var roleString = sift.readStringFromMap(jsonMap, "role");
      role = initializeRoleFromString(roleString);
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast permission response. Error message - ${e.errorMessage}');
    }
  }

  bool shouldShowFinancialWidgets() {
    return role == Roles.financial;
  }

  @override
  Map<String, dynamic> toJson() => {"role": role.toReadableString()};
}
