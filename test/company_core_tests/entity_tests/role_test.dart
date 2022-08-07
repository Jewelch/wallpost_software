import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/company_core/entities/role.dart';

main() {
  test("returns null if role cannot be initialized", () {
    var wrongRoleString = "wrongRole";

    var role = initializeRoleFromString(wrongRoleString);

    expect(role, null);
  });

  test("test initializing roles from string successfully", () {
    var managerString = "general_manager";
    var ownerString = "owner";
    var taskManagerString = "task_line_manager";

    var role1 = initializeRoleFromString(managerString);
    var role2 = initializeRoleFromString(ownerString);
    var role3 = initializeRoleFromString(taskManagerString);

    expect(role1, Role.GeneralManager);
    expect(role2, Role.Owner);
    expect(role3, Role.TaskLineManager);
  });
}
