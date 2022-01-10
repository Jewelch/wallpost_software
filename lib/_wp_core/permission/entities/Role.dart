import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

enum Roles { employee, financial }

Roles initializeRoleFromString(String string) {
  if (string.toLowerCase() == "employee")
    return Roles.employee;
  else if (string.toLowerCase() == "financial")
    return Roles.financial;

  throw MappingException("Failed to cast role response.");
}

extension RolesExtension on Roles {
  String toReadableString() {
    String stringRole;
    switch (this) {
      case Roles.employee:
        stringRole = "employee";
        break;
      case Roles.financial:
        stringRole = "financial";
        break;
      default:
        stringRole = "employee";
    }
    return stringRole;
  }
}
