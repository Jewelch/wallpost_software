import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/permission/repositories/request_items_repository.dart';
import 'package:wallpost/permission/services/permissions_remover.dart';

class MockRequestItemsRepository extends Mock implements RequestItemsRepository {}

main() {
  var repository = MockRequestItemsRepository();
  var remover = PermissionRemover.initWith(repository);

  setUpAll(() {
    when(repository.clearRequestItems).thenAnswer((_) => Future.value(null));
  });

  test('remove permissions removes request items', () {
    remover.removePermissions();

    verify(() => repository.clearRequestItems()).called(1);
  });
}
