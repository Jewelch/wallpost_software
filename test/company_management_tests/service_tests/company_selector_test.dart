import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/company_management/entities/company.dart';
import 'package:wallpost/company_management/repositories/company_repository.dart';
import 'package:wallpost/company_management/services/company_selector.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_user.dart';

class MockCompany extends Mock implements Company {}

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  var mockCurrentUserProvider = MockCurrentUserProvider();
  var mockCompanyRepository = MockCompanyRepository();
  var companySelector = CompanySelector.initWith(mockCurrentUserProvider, mockCompanyRepository);

  test('selecting company does nothing when current user is not available', () async {
    companySelector.selectCompanyForCurrentUser(mockCompany);

    verify(mockCurrentUserProvider.getCurrentUser()).called(1);
    verifyNever(mockCompanyRepository.selectCompanyForUser(any, any)).called(0);
  });

  test('selecting company when current user is available', () async {
    when(mockCurrentUserProvider.getCurrentUser()).thenReturn(mockUser);

    companySelector.selectCompanyForCurrentUser(mockCompany);

    verify(mockCurrentUserProvider.getCurrentUser()).called(1);
    var verificationResult = verify(mockCompanyRepository.selectCompanyForUser(captureAny, captureAny));
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockCompany);
    expect(verificationResult.captured[1], mockUser);
  });
}
