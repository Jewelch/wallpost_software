import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/permission/entities/wp_action.dart';
import 'package:wallpost/permission/repositories/request_items_repository.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

void main() {
  var mockRequestItems = ["leave_request", "expense_request"];
  var mockSharedPrefs = MockSharedPrefs();
  RequestItemsRepository requestRepo = RequestItemsRepository.initWith(mockSharedPrefs);

  setUp(() {
    reset(mockSharedPrefs);
  });

  test('reading requestItems data when no data is available', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));

    var items = await requestRepo.getRequestItemsOfCompany("companyId");

    expect(items, isEmpty);
    verifyInOrder([
      () => mockSharedPrefs.getMap("request_items"),
    ]);
    verifyNoMoreInteractions(mockSharedPrefs);
  });

  test('reading requestItems data  when data is available', () async {
    var companyId = "1";
    when(() => mockSharedPrefs.getMap('request_items')).thenAnswer(
      (_) => Future.value({companyId: mockRequestItems}),
    );

    var items = await requestRepo.getRequestItemsOfCompany(companyId);

    expect(items.length, 2);
    expect(items.contains(WPAction.LeaveRequest), true);
    expect(items.contains(WPAction.ExpenseRequest), true);
    expect(items.contains(WPAction.Task), false);
    expect(items.contains(WPAction.OvertimeRequest), false);
  });

  test('saving new request items, saves items in memory as well as locally', () async {
    var companyId = "1";
    var items = mockRequestItems.map((item) => initializeRequestFromString(item)!).toList();

    await requestRepo.saveRequestItemsForEmployee(companyId, items);

    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'request_items');
    expect(verificationResult.captured[1], {companyId: mockRequestItems});
    expect(await requestRepo.getRequestItemsOfCompany(companyId), items);
  });

  test('removing request items', () async {
    when(() => mockSharedPrefs.getMap('request_items')).thenAnswer(
      (_) => Future.value(null),
    );

    await requestRepo.clearRequestItems();

    var verificationResult = verify(() => mockSharedPrefs.removeMap(captureAny()));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'request_items');
  });
}
