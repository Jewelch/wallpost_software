const _GENERAL_MANAGER_ROLE_STRING = "general_manager";
const _OWNER_ROLE_STRING = "owner";
const _FINANCE_MANAGER_ROLE_STRING = "finance_manager";
const _CRM_MANAGER_ROLE_STRING = "crm_manager";
const _HR_MANAGER_ROLE_STRING = "hr_manager";
const _RESTAURANT_MANAGER_ROLE_STRING = "restaurant_manager";
const _RETAIL_MANAGER_ROLE_STRING = "retail_manager";

enum Role {
  Owner,
  GeneralManager,
  FinanceManager,
  CrmManager,
  HrManager,
  RestaurantManager,
  RetailManager;

  static Role? initFromString(String string) {
    if (string.toLowerCase() == _OWNER_ROLE_STRING)
      return Role.Owner;
    else if (string.toLowerCase() == _GENERAL_MANAGER_ROLE_STRING)
      return Role.GeneralManager;
    else if (string.toLowerCase() == _FINANCE_MANAGER_ROLE_STRING)
      return Role.FinanceManager;
    else if (string.toLowerCase() == _CRM_MANAGER_ROLE_STRING)
      return Role.CrmManager;
    else if (string.toLowerCase() == _HR_MANAGER_ROLE_STRING)
      return Role.HrManager;
    else if (string.toLowerCase() == _RESTAURANT_MANAGER_ROLE_STRING)
      return Role.RestaurantManager;
    else if (string.toLowerCase() == _RETAIL_MANAGER_ROLE_STRING) return Role.RetailManager;

    return null;
  }
}
