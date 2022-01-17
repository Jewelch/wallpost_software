import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

const _GENERAL_MANAGER_ROLE_STRING = "general_manager";
const _OWNER_ROLE_STRING = "owner";
const _TASK_LINE_MANAGER_ROLE_STRING = "task_line_manager";

enum Role {
  Owner,
  GeneralManager,
  TaskLineManager,
}

Role initializeRoleFromString(String string) {
  if (string.toLowerCase() == _OWNER_ROLE_STRING)
    return Role.Owner;
  else if (string.toLowerCase() == _GENERAL_MANAGER_ROLE_STRING)
    return Role.GeneralManager;
  else if (string.toLowerCase() == _TASK_LINE_MANAGER_ROLE_STRING) return Role.TaskLineManager;

  throw MappingException("Failed to cast role response.");
}

extension RolesExtension on Role {
  String toReadableString() {
    switch (this) {
      case Role.Owner:
        return _OWNER_ROLE_STRING;
      case Role.GeneralManager:
        return _GENERAL_MANAGER_ROLE_STRING;
      case Role.TaskLineManager:
        return _TASK_LINE_MANAGER_ROLE_STRING;
    }
  }
}
