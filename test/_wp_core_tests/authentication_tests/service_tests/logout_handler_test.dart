import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';
import 'package:wallpost/_wp_core/user_management/services/logout_handler.dart';
import 'package:wallpost/_wp_core/company_management/services/user_companies_remover.dart';

import '../../../_mocks/mock_current_user_provider.dart';

class MockUserRemover extends Mock implements UserRemover {}

class MockUserCompaniesRemover extends Mock implements UserCompaniesRemover {}

void main() {
  test('logging out clears all the data', () async {
    var currentUserProvider = MockCurrentUserProvider();
    var userRemover = MockUserRemover();
    var companiesRemover = MockUserCompaniesRemover();
    var logoutHandler = LogoutHandler.initWith(currentUserProvider, userRemover, companiesRemover);

    logoutHandler.logout(null);

    verify(currentUserProvider.getCurrentUser()).called(1);
    verify(userRemover.removeUser(any)).called(1);
    verify(companiesRemover.removeCompaniesForUser(any)).called(1);
  });
}
