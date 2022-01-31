import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/company_management/entities/company.dart';
import 'package:wallpost/_wp_core/company_management/entities/employee.dart';
import 'package:wallpost/permission/entities/permissions.dart';
import 'package:wallpost/permission/entities/request_item.dart';

class MockCompany extends Mock implements Company {}

class MockEmployee extends Mock implements Employee {}

main() {
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();

  group(
      "test create task permission, only employees have task request item can request",
      () {
    test("employee don't have task request item", () {
      var requestItems = <RequestItem>[];

      var permissions =
          Permissions.initWith(mockCompany, mockEmployee, requestItems);

      expect(permissions.canCreateTask(), false);
    });

    test("employee do have task request item", () {
      var requestItems = <RequestItem>[RequestItem.Task];

      var permissions =
          Permissions.initWith(mockCompany, mockEmployee, requestItems);

      expect(permissions.canCreateTask(), true);
    });
  });

  group(
      "test create expense request, only employees have expense request item can request",
      () {
    test("employee don't have expense request item", () {
      var requestItems = <RequestItem>[];

      var permissions =
          Permissions.initWith(mockCompany, mockEmployee, requestItems);

      expect(permissions.canCreateTask(), false);
    });

    test("employee do have expense request item", () {
      var requestItems = <RequestItem>[RequestItem.ExpenseRequest];

      var permissions =
          Permissions.initWith(mockCompany, mockEmployee, requestItems);

      expect(permissions.canCreateExpenseRequest(), true);
    });
  });
}
