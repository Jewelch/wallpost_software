import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_user.dart';

class MockUserRemover extends Mock implements UserRemover {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockUser());
  });

  test('logging out clears all the data', () async {
    var currentUserProvider = MockCurrentUserProvider();
    var userRemover = MockUserRemover();
    var logoutHandler = LogoutHandler.initWith(currentUserProvider, userRemover);
    when(() => currentUserProvider.getCurrentUser()).thenReturn(MockUser());
    when(() => userRemover.removeUser(any())).thenAnswer((invocation) => Future.value(null));

    logoutHandler.logout(null);

    verifyInOrder([
      () => currentUserProvider.getCurrentUser(),
      () => userRemover.removeUser(any()),
    ]);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(userRemover);
  });
}
