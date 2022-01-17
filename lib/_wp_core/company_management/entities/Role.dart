import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

enum Roles {
  generalManager,
  owner,
  taskLineManager,
}

Roles initializeRoleFromString(String string) {
  if (string.toLowerCase() == "general_manager")
    return Roles.generalManager;
  else if (string.toLowerCase() == "owner")
    return Roles.owner;
  else if (string.toLowerCase() == 'task_line_manager')
    return Roles.taskLineManager;
  throw MappingException("Failed to cast role response.");
}

extension RolesExtension on Roles {
  String toReadableString() {
    String stringRole;
    switch (this) {
      case Roles.generalManager:
        stringRole = "general_manager";
        break;
      case Roles.owner:
        stringRole = "owner";
        break;
      case Roles.taskLineManager:
        stringRole = "task_line_manager";
        break;
      default:
        stringRole = "employee";
    }
    return stringRole;
  }
}
