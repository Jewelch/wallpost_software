// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';

import '../../../_mocks/mock_user.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  var mockUser = MockUser();
  var mockUserRepository = MockUserRepository();
  var mockCurrentUserProvider = CurrentUserProvider.initWith(mockUserRepository);

  test('returns the current user from the user repository', () async {
    when(mockUserRepository.getCurrentUser()).thenReturn(mockUser);
    when(mockUser.username).thenReturn('someUserName');

    var currentUser = mockCurrentUserProvider.getCurrentUser();

    expect(currentUser.username, 'someUserName');
    verify(mockUserRepository.getCurrentUser()).called(1);
  });
}
