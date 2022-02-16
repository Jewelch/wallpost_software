import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/entities/wp_action.dart';
import 'package:wallpost/permission/permissions.dart';

class MockCompany extends Mock implements Company {}

class MockEmployee extends Mock implements Employee {}

main() {
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();

  group("test create task permission, only employees have task wp action allowed", () {
    test("employee don't have task wp action", () {
      var epActions = <WPAction>[];

      var permissions = Permissions.initWith(mockCompany, mockEmployee, epActions);

      expect(permissions.canCreateTask(), false);
    });

    test("employee do have task wp action", () {
      var wpActions = <WPAction>[WPAction.Task];

      var permissions = Permissions.initWith(mockCompany, mockEmployee, wpActions);

      expect(permissions.canCreateTask(), true);
    });
  });

  group("test create expense request, only employees have expense wp action allowed", () {
    test("employee don't have expense wp action ", () {
      var wpActions = <WPAction>[];

      var permissions = Permissions.initWith(mockCompany, mockEmployee, wpActions);

      expect(permissions.canCreateTask(), false);
    });

    test("employee do have expense wp action ", () {
      var wpActions = <WPAction>[WPAction.ExpenseRequest];

      var permissions = Permissions.initWith(mockCompany, mockEmployee, wpActions);

      expect(permissions.canCreateExpenseRequest(), true);
    });
  });
}
