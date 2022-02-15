import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_list/entities/company.dart';
import 'package:wallpost/company_list/entities/employee.dart';
import 'package:wallpost/company_list/services/selected_company_provider.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';
import 'package:wallpost/permission/entities/request_item.dart';
import 'package:wallpost/permission/repositories/request_items_repository.dart';
import 'package:wallpost/permission/services/permission_provider.dart';

class MockSelectedCompanyProvider extends Mock implements SelectedCompanyProvider {}

class MockSelectedEmployeeProvider extends Mock implements SelectedEmployeeProvider {}

class MockRequestItemsRepository extends Mock implements RequestItemsRepository {}

class MockEmployee extends Mock implements Employee {}

class MockCompany extends Mock implements Company {}

main() {
  var companyProvider = MockSelectedCompanyProvider();
  var employeeProvider = MockSelectedEmployeeProvider();
  var requestItemsProvider = MockRequestItemsRepository();
  var mockCompany = MockCompany();
  var mockEmployee = MockEmployee();
  var mockRequestItems = [RequestItem.OvertimeRequest, RequestItem.LeaveRequest];
  setUp(() {
    when(() => mockCompany.id).thenReturn("1");
    when(companyProvider.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    when(employeeProvider.getSelectedEmployeeForCurrentUser).thenReturn(mockEmployee);
    when(() => requestItemsProvider.getRequestItemsOfCompany(any()))
        .thenAnswer((_) => Future.value(mockRequestItems));
  });

  test("test getting permissions", () async {
    var permissionProvider =
        PermissionProvider.initWith(companyProvider, employeeProvider, requestItemsProvider);

    var permissions = await permissionProvider.getPermissions();

    verify(() => companyProvider.getSelectedCompanyForCurrentUser()).called(1);
    verify(() => employeeProvider.getSelectedEmployeeForCurrentUser()).called(1);
    verify(() => requestItemsProvider.getRequestItemsOfCompany(mockCompany.id)).called(1);
    expect(permissions.canCreateExpenseRequest(), false);
  });
}
