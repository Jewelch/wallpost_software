import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/entities/wp_action.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

class MockEmployee extends Mock implements Employee {}

//TODO ABDO
void main() {
  var mockWpActions = ["leave_request", "expense_request"];
  var mockSharedPrefs = MockSharedPrefs();
  var mockEmployee = MockEmployee();
  late AllowedActionsRepository allowedWpActionsRepo;

  setUp(() async {
    reset(mockSharedPrefs);
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    when(() => mockEmployee.v1Id).thenReturn("1");
    allowedWpActionsRepo = AllowedActionsRepository.withSharedPrefs(mockSharedPrefs);
    Future.delayed(Duration(milliseconds: 10));
  });

  test('reading wp actions data when no data is available', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));

    var items = allowedWpActionsRepo.getAllowedActionsForEmployee(mockEmployee);

    expect(items, isEmpty);
    verifyInOrder([
      () => mockSharedPrefs.getMap("wp_actions"),
    ]);
    verifyNoMoreInteractions(mockSharedPrefs);
  });

  test('saving new wp action, saves wp actions in memory as well as locally', () async {
    var wpActions = mockWpActions.map((item) => initializeWpActionFromString(item)!).toList();

    allowedWpActionsRepo.saveActionsForEmployee(wpActions, mockEmployee);

    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'wp_actions');
    expect(verificationResult.captured[1], {"1": mockWpActions});
    expect(allowedWpActionsRepo.getAllowedActionsForEmployee(mockEmployee), wpActions);
  });

  test('reading wp actions data when data is available', () async {
    var wpActions = mockWpActions.map((item) => initializeWpActionFromString(item)!).toList();
    when(() => mockSharedPrefs.getMap('wp_actions')).thenAnswer(
      (_) => Future.value({"1": mockWpActions}),
    );

    allowedWpActionsRepo.saveActionsForEmployee(wpActions, mockEmployee);
    var items = allowedWpActionsRepo.getAllowedActionsForEmployee(mockEmployee);

    expect(items.length, 2);
    expect(items.contains(WPAction.LeaveRequest), true);
    expect(items.contains(WPAction.ExpenseRequest), true);
    expect(items.contains(WPAction.Task), false);
    expect(items.contains(WPAction.OvertimeRequest), false);
  });

  test('removing wp actions', () async {
    when(() => mockSharedPrefs.getMap('wp_actions')).thenAnswer(
      (_) => Future.value(null),
    );

    await allowedWpActionsRepo.removeAllAllowedActions();

    var verificationResult = verify(() => mockSharedPrefs.removeMap(captureAny()));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'wp_actions');
  });
}
