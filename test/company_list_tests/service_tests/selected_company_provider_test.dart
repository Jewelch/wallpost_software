import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/company_list/entities/company.dart';
import 'package:wallpost/company_list/repositories/company_repository.dart';
import 'package:wallpost/company_list/services/selected_company_provider.dart';

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

  setUpAll(() {
    registerFallbackValue(MockUser());
  });

  setUp(() {
    reset(mockCurrentUserProvider);
    reset(mockCompanyRepository);
  });

  test('checking if a company is selected or not', () async {
    when(() => mockCurrentUserProvider.getCurrentUser()).thenReturn(mockUser);

    when(() => mockCompanyRepository.getSelectedCompanyForUser(any())).thenReturn(null);
    expect(selectedCompanyProvider.isCompanySelected(), false);

    when(() => mockCompanyRepository.getSelectedCompanyForUser(any())).thenReturn(MockCompany());
    expect(selectedCompanyProvider.isCompanySelected(), true);
  });

  test('getting selected company for current user', () async {
    when(() => mockCurrentUserProvider.getCurrentUser()).thenReturn(mockUser);
    when(() => mockCompanyRepository.getSelectedCompanyForUser(any())).thenReturn(mockCompany);

    var selectedCompany = selectedCompanyProvider.getSelectedCompanyForCurrentUser();

    expect(selectedCompany, mockCompany);
    verify(() => mockCurrentUserProvider.getCurrentUser()).called(1);
    var verificationResult = verify(() => mockCompanyRepository.getSelectedCompanyForUser(captureAny()));
    verificationResult.called(1);
    expect(verificationResult.captured[0], mockUser);
  });
}
