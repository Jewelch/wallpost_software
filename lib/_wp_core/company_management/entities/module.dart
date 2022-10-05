const _HR_MODULE_STRING = "hr";
const _FINANCE_MODULE_STRING = "finance";

enum Module {
  Hr,
  Finance;

  static Module? initFromString(String string) {
    if (string.toLowerCase() == _HR_MODULE_STRING) return Module.Hr;
    if (string.toLowerCase() == _FINANCE_MODULE_STRING) return Module.Finance;

    return null;
  }

  String toReadableString() {
    switch (this) {
      case Module.Hr:
        return "HR";
      case Module.Finance:
        return "Finance";
    }
  }
}
