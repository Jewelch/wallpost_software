import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/company_list/services/company_list_remover.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';
import 'package:wallpost/permission/services/permissions_remover.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_user.dart';

class MockUserRemover extends Mock implements UserRemover {}

class MockUserCompaniesRemover extends Mock implements CompanyListRemover {}

class MockPermissionRemover extends Mock implements PermissionRemover {}

void main() {
  setUpAll(() {
    registerFallbackValue(MockUser());
  });

  test('logging out clears all the data', () async {
    var currentUserProvider = MockCurrentUserProvider();
    var userRemover = MockUserRemover();
    var companiesRemover = MockUserCompaniesRemover();
    var permissionRemover = MockPermissionRemover();
    var logoutHandler = LogoutHandler.initWith(
        currentUserProvider, userRemover, companiesRemover, permissionRemover);
    when(() => currentUserProvider.getCurrentUser()).thenReturn(MockUser());

    logoutHandler.logout(null);

    verifyInOrder([
      () => currentUserProvider.getCurrentUser(),
      () => userRemover.removeUser(any()),
      () => companiesRemover.removeCompaniesForUser(any()),
      () => permissionRemover.removePermissions(),
    ]);
    verifyNoMoreInteractions(currentUserProvider);
    verifyNoMoreInteractions(userRemover);
    verifyNoMoreInteractions(companiesRemover);
    verifyNoMoreInteractions(permissionRemover);
  });
}
