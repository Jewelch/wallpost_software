import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/permissions/permissions_provider.dart';

import '../_mocks/mock_company.dart';
import '../_mocks/mock_company_provider.dart';
import '../_mocks/mock_employee.dart';

void main() {
  var company = MockCompany();
  var selectedCompanyProvider = MockCompanyProvider();
  var provider = PermissionsProvider.initWith(selectedCompanyProvider);

  setUpAll(() {
    when(() => selectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test("get should show owner dashboard", () {
    var employee = MockEmployee();
    when(() => company.employee).thenReturn(employee);

    when(() => employee.isOwner()).thenReturn(true);
    expect(provider.shouldShowOwnerDashboard(), true);
    expect(provider.shouldShowManagerDashboard(), false);

    when(() => employee.isGM()).thenReturn(true);
    expect(provider.shouldShowOwnerDashboard(), true);
    expect(provider.shouldShowManagerDashboard(), false);
  });

  test("get should show manager dashboard", () {
    var employee = MockEmployee();
    when(() => employee.isOwner()).thenReturn(false);
    when(() => employee.isGM()).thenReturn(false);
    when(() => company.employee).thenReturn(employee);
    expect(provider.shouldShowOwnerDashboard(), false);

    when(() => employee.isAFinanceManager()).thenReturn(true);
    expect(provider.shouldShowManagerDashboard(), true);

    when(() => employee.isAFinanceManager()).thenReturn(false);
    when(() => employee.isACrmManager()).thenReturn(true);
    expect(provider.shouldShowManagerDashboard(), true);

    when(() => employee.isAFinanceManager()).thenReturn(false);
    when(() => employee.isACrmManager()).thenReturn(false);
    when(() => employee.isAHrManager()).thenReturn(true);
    expect(provider.shouldShowManagerDashboard(), true);

    when(() => employee.isAFinanceManager()).thenReturn(false);
    when(() => employee.isACrmManager()).thenReturn(false);
    when(() => employee.isAHrManager()).thenReturn(false);
    when(() => employee.isARestaurantManager()).thenReturn(true);
    expect(provider.shouldShowManagerDashboard(), true);

    when(() => employee.isAFinanceManager()).thenReturn(false);
    when(() => employee.isACrmManager()).thenReturn(false);
    when(() => employee.isAHrManager()).thenReturn(false);
    when(() => employee.isARestaurantManager()).thenReturn(false);
    when(() => employee.isARetailManager()).thenReturn(true);
    expect(provider.shouldShowManagerDashboard(), true);
  });
}
