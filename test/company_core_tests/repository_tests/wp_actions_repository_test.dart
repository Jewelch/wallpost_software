import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/company_core/entities/wp_action.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

void main() {
  //TODO ABDO
  // var mockRequestItems = ["leave_request", "expense_request"];
  // var mockSharedPrefs = MockSharedPrefs();
  // AllowedActionsRepository requestRepo = AllowedActionsRepository.initWith(mockSharedPrefs);
  //
  // setUp(() {
  //   reset(mockSharedPrefs);
  // });
  //
  // test('reading requestItems data when no data is available', () async {
  //   when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
  //
  //   var items = await requestRepo.getAllowedActionsForEmployee("companyId");
  //
  //   expect(items, isEmpty);
  //   verifyInOrder([
  //     () => mockSharedPrefs.getMap("wp_actions"),
  //   ]);
  //   verifyNoMoreInteractions(mockSharedPrefs);
  // });
  //
  // test('reading requestItems data when data is available', () async {
  //   var companyId = "1";
  //   when(() => mockSharedPrefs.getMap('wp_actions')).thenAnswer(
  //     (_) => Future.value({companyId: mockRequestItems}),
  //   );
  //
  //   var items = await requestRepo.getAllowedActionsForEmployee(companyId);
  //
  //   expect(items.length, 2);
  //   expect(items.contains(WPAction.LeaveRequest), true);
  //   expect(items.contains(WPAction.ExpenseRequest), true);
  //   expect(items.contains(WPAction.Task), false);
  //   expect(items.contains(WPAction.OvertimeRequest), false);
  // });
  //
  // test('saving new request items, saves items in memory as well as locally', () async {
  //   var companyId = "1";
  //   var items = mockRequestItems.map((item) => initializeRequestFromString(item)!).toList();
  //
  //   await requestRepo.saveAllowedActionsForEmployee(companyId, items);
  //
  //   var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));
  //
  //   verificationResult.called(1);
  //   expect(verificationResult.captured[0], 'wp_actions');
  //   expect(verificationResult.captured[1], {companyId: mockRequestItems});
  //   expect(await requestRepo.getAllowedActionsForEmployee(companyId), items);
  // });
  //
  // test('removing request items', () async {
  //   when(() => mockSharedPrefs.getMap('wp_actions')).thenAnswer(
  //     (_) => Future.value(null),
  //   );
  //
  //   await requestRepo.clearRequestItems();
  //
  //   var verificationResult = verify(() => mockSharedPrefs.removeMap(captureAny()));
  //
  //   verificationResult.called(1);
  //   expect(verificationResult.captured[0], 'wp_actions');
  // });
}
