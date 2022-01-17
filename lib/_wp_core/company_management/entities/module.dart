const _TASK_MODULE_STRING = "task";
const _HR_MODULE_STRING = "hr";
const _PERFORMANCE_MODULE_STRING = "performance";

enum Module {
  Task,
  Hr,
  Performance,
}

Module? initializeModuleFromString(String string) {
  if (string.toLowerCase() == _TASK_MODULE_STRING)
    return Module.Task;
  else if (string.toLowerCase() == _HR_MODULE_STRING)
    return Module.Hr;
  else if (string.toLowerCase() == _PERFORMANCE_MODULE_STRING) return Module.Performance;

  return null;
}

extension ModuleExtension on Module {
  String toReadableString() {
    switch (this) {
      case Module.Task:
        return _TASK_MODULE_STRING;
      case Module.Hr:
        return _HR_MODULE_STRING;
      case Module.Performance:
        return _PERFORMANCE_MODULE_STRING;
    }
  }
}
