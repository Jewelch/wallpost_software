import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/permission/entities/permission.dart';
import 'package:wallpost/_wp_core/company_management/entities/role.dart';

main() {
  // test("test initialize Permission from json successfully", () {
  //   var roleMap = {'role': 'owner'};
  //
  //   Permission permission = Permission.fromJson(roleMap);
  //
  //   expect(permission.role, Role.Owner);
  // });
  //
  // test("test initialize Permission with invalid data throws Mapping exception",
  //     () {
  //   var wrongRoleMap = {'rolee': 'employee'};
  //
  //   try {
  //     Permission.fromJson(wrongRoleMap);
  //     assert(false);
  //   } catch (e) {
  //     expect(e is MappingException, true);
  //   }
  // });

  // test("test only financials can see financials widgets", () {
  //   var ownerMap = {'role': 'owner'};
  //   var managerMap = {'role': 'general_manager'};
  //
  //   var permission1 = Permission.fromJson(ownerMap);
  //   var permission2 = Permission.fromJson(managerMap);
  //
  //   expect(permission1.shouldShowFinancialWidgets(), false);
  //   expect(permission2.shouldShowFinancialWidgets(), true);
  // });
}
