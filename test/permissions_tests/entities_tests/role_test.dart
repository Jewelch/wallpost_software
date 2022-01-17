import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/Role.dart';

main() {
  test("test initializing Roles from string successfully", () {
    var managerString = "general_manager";
    var ownerString = "owner";
    var taskManagerString = "task_line_manager";

    var role1 = initializeRoleFromString(managerString);
    var role2 = initializeRoleFromString(ownerString);
    var role3 = initializeRoleFromString(taskManagerString);

    expect(role1, Roles.generalManager);
    expect(role2, Roles.owner);
    expect(role3, Roles.taskLineManager);
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
    var managerRole = Roles.generalManager;
    var ownerRole = Roles.owner;
    var taskManagerRole = Roles.taskLineManager;

    var managerString = managerRole.toReadableString();
    var ownerString = ownerRole.toReadableString();
    var taskManagerString = taskManagerRole.toReadableString();

    expect(managerString, "general_manager");
    expect(ownerString, "owner");
    expect(taskManagerString, "task_line_manager");
  });
}
