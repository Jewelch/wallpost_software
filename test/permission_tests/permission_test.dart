import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/entities/employee.dart';

import 'package:wallpost/company_core/entities/wp_action.dart';

class MockCompany extends Mock implements Company {}

class MockEmployee extends Mock implements Employee {}
//TODO ABDO
main() {
  // var mockCompany = MockCompany();
  // var mockEmployee = MockEmployee();
  //
  // group("test create task permission, only employees have task request item can request", () {
  //   test("employee don't have task request item", () {
  //     var requestItems = <WPAction>[];
  //
  //     var permissions = Permission.initWith(mockCompany, mockEmployee, requestItems);
  //
  //     expect(permissions.canCreateTask(), false);
  //   });
  //
  //   test("employee do have task request item", () {
  //     var requestItems = <WPAction>[WPAction.Task];
  //
  //     var permissions = Permission.initWith(mockCompany, mockEmployee, requestItems);
  //
  //     expect(permissions.canCreateTask(), true);
  //   });
  // });
  //
  // group("test create expense request, only employees have expense request item can request", () {
  //   test("employee don't have expense request item", () {
  //     var requestItems = <WPAction>[];
  //
  //     var permissions = Permission.initWith(mockCompany, mockEmployee, requestItems);
  //
  //     expect(permissions.canCreateTask(), false);
  //   });
  //
  //   test("employee do have expense request item", () {
  //     var requestItems = <WPAction>[WPAction.ExpenseRequest];
  //
  //     var permissions = Permission.initWith(mockCompany, mockEmployee, requestItems);
  //
  //     expect(permissions.canCreateExpenseRequest(), true);
  //   });
  // });
}
