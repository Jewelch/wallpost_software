import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_wp_core/permission/entities/role.dart';

main() {
  test("test initializing Roles from string successfully", () {
    var employeeString = "employee";
    var financialString = "financial";

    var role1 = initializeRoleFromString(employeeString);
    var role2 = initializeRoleFromString(financialString);

    expect(role1, Roles.employee);
    expect(role2, Roles.financial);
  });

  test("test initializing Roles from wrong data throw mapping exception", () {
    var wrongRoleString = "wrongEmployee";

    try {
      initializeRoleFromString(wrongRoleString);
      assert(false);
    } catch (e) {
      expect(e is MappingException, true);
    }
  });

  test("test convert Roles to string", () {
    var employeeRole = Roles.employee;
    var financialRole = Roles.financial;

    var stringEmployeeRole = employeeRole.toReadableString();
    var stringFinancialRole = financialRole.toReadableString();

    expect(stringEmployeeRole, "employee");
    expect(stringFinancialRole, "financial");
  });
}
