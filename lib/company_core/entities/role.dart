const _GENERAL_MANAGER_ROLE_STRING = "general_manager";
const _OWNER_ROLE_STRING = "owner";
const _TASK_LINE_MANAGER_ROLE_STRING = "task_line_manager";

enum Role {
  Owner,
  GeneralManager,
  TaskLineManager,
}

Role? initializeRoleFromString(String string) {
  if (string.toLowerCase() == _OWNER_ROLE_STRING)
    return Role.Owner;
  else if (string.toLowerCase() == _GENERAL_MANAGER_ROLE_STRING)
    return Role.GeneralManager;
  else if (string.toLowerCase() == _TASK_LINE_MANAGER_ROLE_STRING) return Role.TaskLineManager;

  return null;
}
