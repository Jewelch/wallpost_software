const _HR_MODULE_STRING = "hr";
const _CRM_MODULE_STRING = "crm";
const _RESTAURANT_MODULE_STRING = "restaurant";
const _RETAIL_MODULE_STRING = "retail";
const _FINANCE_MODULE_STRING = "finance";

enum Module {
  Hr,
  Crm,
  Restaurant,
  Retail,
  Finance;

  static Module? initFromString(String string) {
    if (string.toLowerCase() == _HR_MODULE_STRING) return Module.Hr;
    if (string.toLowerCase() == _CRM_MODULE_STRING) return Module.Crm;
    if (string.toLowerCase() == _RESTAURANT_MODULE_STRING) return Module.Restaurant;
    if (string.toLowerCase() == _RETAIL_MODULE_STRING) return Module.Retail;
    if (string.toLowerCase() == _FINANCE_MODULE_STRING) return Module.Finance;

    return null;
  }

  String toReadableString() {
    switch (this) {
      case Module.Hr:
        return "HR";
      case Module.Crm:
        return "CRM";
      case Module.Restaurant:
        return "Restaurant";
      case Module.Retail:
        return "Retail";
      case Module.Finance:
        return "Finance";
    }
  }
}
