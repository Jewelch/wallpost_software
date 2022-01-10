import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/permission.dart';
import 'package:wallpost/_wp_core/permission/entities/role.dart';

main() {
  test("test initialize permission from json successfully", () {
    var roleMap = {'role': 'employee'};

    Permissions permission = Permissions.fromJson(roleMap);

    expect(permission.role, Roles.employee);
  });

  test("test initialize Permission with invalid data throws Mapping exception", () {
    var wrongRoleMap = {'rolee': 'employee'};

    try {
      Permissions.fromJson(wrongRoleMap);
      assert(false);
    } catch (e) {
      expect(e is MappingException, true);
    }
  });

  test("test only financials can see financials widgets", () {
    var employeeMap = {'role': 'employee'};
    var financialMap = {'role': 'financial'};

    var permission1 = Permissions.fromJson(employeeMap);
    var permission2 = Permissions.fromJson(financialMap);

    expect(permission1.shouldShowFinancialWidgets(), false);
    expect(permission2.shouldShowFinancialWidgets(), true);
  });
}
