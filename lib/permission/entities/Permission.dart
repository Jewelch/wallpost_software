import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_wp_core/company_management/entities/Role.dart';

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

  bool shouldShowFinancialWidgets()=> false;

  // company has task module and user role doesn't matter
  bool canCreateTask()=> false;

  // company has task module and ? confirm with Niyas
  // 1 company for the modules
  // 2 employee for the role



  bool canRequestLeave()=> false;

  bool canRequestExpense()=> false;

  bool canCreateOvertime()=> false;

  bool canShowManagementViews()=> false;

  // bool canApproveEmployeeHandover()=> false;
  // bool canApproveExpense()=> false;
  // bool canApproveTask()=> false;
  // bool canApproveLeave()=> false;
  // bool canApproveAttendanceAdjustment()=> false;

  @override
  Map<String, dynamic> toJson() => {"role": role.toReadableString()};
}
