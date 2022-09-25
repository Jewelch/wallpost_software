const _HR_MODULE_STRING = "hr";

enum Module {
  Hr;

  static Module? initFromString(String string) {
    if (string.toLowerCase() == _HR_MODULE_STRING) return Module.Hr;

    return null;
  }

  String toReadableString() {
    return "HR";
  }
}
