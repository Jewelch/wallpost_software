import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/entities/wp_action.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';
import 'package:wallpost/company_core/services/selected_employee_actions_provider.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class MockAllowedActionsRepository extends Mock implements AllowedActionsRepository {}

class MockSelectedEmployeeProvider extends Mock implements SelectedEmployeeProvider {}

class MockEmployee extends Mock implements Employee {}

main() {
  var mockEmployee = MockEmployee();
  var mockSelectedEmployeeProvider = MockSelectedEmployeeProvider();
  var repository = MockAllowedActionsRepository();
  var mockActions = [WPAction.OvertimeRequest];
  late SelectedEmployeeActionsProvider selectedEmployeeActionsProvider;

  setUpAll(() {
    registerFallbackValue(MockEmployee());
    when(mockSelectedEmployeeProvider.getSelectedEmployeeForCurrentUser).thenReturn(mockEmployee);
    when(() => repository.getAllowedActionsForEmployee(any())).thenReturn(mockActions);
  });

  test("test getting allowed for employee actions", () {
    selectedEmployeeActionsProvider =
        SelectedEmployeeActionsProvider.initWith(mockSelectedEmployeeProvider, repository);

    var actions = selectedEmployeeActionsProvider.getAllowedActionsForSelectedEmployee();

    expect(actions, mockActions);
  });
}
