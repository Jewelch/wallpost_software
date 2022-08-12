import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/new_user_adder.dart';

import '../../../_mocks/mock_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  var mockUser = MockUser();
  var mockUserRepository = MockUserRepository();
  var newUserAdder = NewUserAdder.initWith(mockUserRepository);

  setUpAll(() {
    registerFallbackValue(MockUser());
  });

  test('adding a user adds it to the user repository', () async {
    when(() => mockUserRepository.saveNewCurrentUser(any())).thenAnswer((_) => Future.value(null));

    newUserAdder.addUser(mockUser);

    expect(verify(() => mockUserRepository.saveNewCurrentUser(captureAny())).captured.single, mockUser);
  });
}
