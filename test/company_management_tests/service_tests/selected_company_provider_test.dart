import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_wp_core/company_management/entities/company.dart';
import 'package:wallpost/_wp_core/company_management/repositories/company_repository.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_user.dart';

class MockCompany extends Mock implements Company {}

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  var mockUser = MockUser();
  var mockCompany = MockCompany();
  var mockCurrentUserProvider = MockCurrentUserProvider();
  var mockCompanyRepository = MockCompanyRepository();
  var selectedCompanyProvider = SelectedCompanyProvider.initWith(mockCurrentUserProvider, mockCompanyRepository);

  test('returns null if there is no current user', () async {
    when(mockCurrentUserProvider.getCurrentUser()).thenReturn(null);

    var selectedCompany = selectedCompanyProvider.getSelectedCompanyForCurrentUser();

    expect(selectedCompany, null);
    verify(mockCurrentUserProvider.getCurrentUser()).called(1);
    verifyNever(mockCompanyRepository.getSelectedCompanyForUser(any));
  });

  test('getting selected company for current user', () async {
    when(mockCurrentUserProvider.getCurrentUser()).thenReturn(mockUser);
    when(mockCompanyRepository.getSelectedCompanyForUser(any)).thenReturn(mockCompany);

    var selectedCompany = selectedCompanyProvider.getSelectedCompanyForCurrentUser();

    expect(selectedCompany, mockCompany);
    verify(mockCurrentUserProvider.getCurrentUser()).called(1);
    var verificationResult = verify(mockCompanyRepository.getSelectedCompanyForUser(captureAny));
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockUser);
  });
}
