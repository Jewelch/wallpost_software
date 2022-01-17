import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

const _TASK_MODULE_STRING = "task";
const _HR_MODULE_STRING = "hr";
const _CRM_MODULE_STRING = "crm";
const _FINANCE_MODULE_STRING = "finance";
const _PERFORMANCE_MODULE_STRING = "performance";

enum Module {
  Task,
  Hr,
  Crm,
  Finance,
  Performance,
}

Module initializeModuleFromString(String string) {
  if (string.toLowerCase() == _TASK_MODULE_STRING)
    return Module.Task;
  else if (string.toLowerCase() == _HR_MODULE_STRING)
    return Module.Hr;
  else if (string.toLowerCase() == _CRM_MODULE_STRING)
    return Module.Crm;
  else if (string.toLowerCase() == _FINANCE_MODULE_STRING)
    return Module.Finance;
  else if (string.toLowerCase() == _PERFORMANCE_MODULE_STRING) return Module.Performance;

  throw MappingException("Failed to cast module response.");
}

extension ModuleExtension on Module {
  String toReadableString() {
    switch (this) {
      case Module.Task:
        return _TASK_MODULE_STRING;
      case Module.Hr:
        return _HR_MODULE_STRING;
      case Module.Crm:
        return _CRM_MODULE_STRING;
      case Module.Finance:
        return _FINANCE_MODULE_STRING;
      case Module.Performance:
        return _PERFORMANCE_MODULE_STRING;
    }
  }
}
