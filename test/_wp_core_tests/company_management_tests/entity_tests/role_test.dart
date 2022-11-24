import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/company_management/entities/role.dart';

main() {
  test("returns null if role cannot be initialized", () {
    var wrongRoleString = "wrongRole";

    var role = Role.initFromString(wrongRoleString);

    expect(role, null);
  });

  test("test initializing roles from string successfully", () {
    var managerString = "general_manager";
    var ownerString = "owner";
    var financeManagerString = "finance_manager";
    var crmManagerString = "crm_manager";
    var hrManagerString = "hr_manager";
    var restaurantManagerString = "restaurant_manager";
    var retailManagerString = "retail_manager";

    var role1 = Role.initFromString(managerString);
    var role2 = Role.initFromString(ownerString);
    var role3 = Role.initFromString(financeManagerString);
    var role4 = Role.initFromString(crmManagerString);
    var role5 = Role.initFromString(hrManagerString);
    var role6 = Role.initFromString(restaurantManagerString);
    var role7 = Role.initFromString(retailManagerString);

    expect(role1, Role.GeneralManager);
    expect(role2, Role.Owner);
    expect(role3, Role.FinanceManager);
    expect(role4, Role.CrmManager);
    expect(role5, Role.HrManager);
    expect(role6, Role.RestaurantManager);
    expect(role7, Role.RetailManager);
  });
}
