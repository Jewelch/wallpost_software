import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/company_core/entities/employee.dart';

import '../mocks.dart';

main() {
  test("is owner", () {
    var ownerMap = Mocks.companiesListResponse["companies"][0];
    ownerMap["employee"]["Roles"] = ["owner"];

    var employee = Employee.fromJson(ownerMap);

    expect(employee.isOwner(), true);
    expect(employee.isGM(), false);
  });

  test("is general manager", () {
    var gmMap = Mocks.companiesListResponse["companies"][0];
    gmMap["employee"]["Roles"] = ["general_manager"];

    var employee = Employee.fromJson(gmMap);

    expect(employee.isGM(), true);
    expect(employee.isOwner(), false);
  });
}
