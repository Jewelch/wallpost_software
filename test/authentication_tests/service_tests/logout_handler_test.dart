import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/user_management/services/user_remover.dart';
import 'package:wallpost/authentication/services/logout_handler.dart';
import 'package:wallpost/company_management/services/company_remover.dart';

import '../../_mocks/mock_current_user_provider.dart';

class MockUserRemover extends Mock implements UserRemover {}

class MockCompanyRemover extends Mock implements CompanyRemover {}

void main() {
  test('logging out clears all the data', () async {
    var currentUserProvider = MockCurrentUserProvider();
    var userRemover = MockUserRemover();
    var companyRemover = MockCompanyRemover();
    var logoutHandler = LogoutHandler.initWith(currentUserProvider, userRemover, companyRemover);

    logoutHandler.logout(null);

    verify(currentUserProvider.getCurrentUser()).called(1);
    verify(userRemover.removeUser(any)).called(1);
    verify(companyRemover.removeCompaniesForUser(any)).called(1);
  });
}
