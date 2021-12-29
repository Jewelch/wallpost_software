import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';

import '../../../_mocks/mock_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  var mockUser = MockUser();
  var mockUserRepository = MockUserRepository();
  var userRemover = UserRemover.initWith(mockUserRepository);

  setUpAll(() {
    registerFallbackValue(MockUser());
  });

  test('removing current user', () async {
    userRemover.removeUser(mockUser);

    expect(verify(() => mockUserRepository.removeUser(captureAny())).captured.single, mockUser);
  });
}
