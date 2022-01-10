import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_wp_core/permission/entities/role.dart';

class Permissions implements JSONInitializable, JSONConvertible {
  /*
  - there are list of roles - we'll probably need the role class
  "Roles": [
        "task_line_manager"
      ],
  - ask niyas for all the roles
  - permissions are not just based on roles it can be based on other details as well -
  we  will store all  the required details in this class and store it locally.

  idea is to store data in raw format
   */
  late Roles role;
  late bool isTrial;

  Permissions.fromJson(Map<String, dynamic> jsonMap) {
    var sift = Sift();
    try {
      var roleString = sift.readStringFromMap(jsonMap, "role");
      var isTrails = sift.readStringFromMap(jsonMap, "isTrail");
      role = initializeRoleFromString(roleString);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast permission response. Error message - ${e.errorMessage}');
    }
  }

  bool shouldShowFinancialWidgets() {
    return role == Roles.financial;
  }

  @override
  Map<String, dynamic> toJson() => {"role": role.toReadableString()};
}
