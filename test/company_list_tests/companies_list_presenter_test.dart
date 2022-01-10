import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';

class MockCompaniesListViewView extends Mock implements CompaniesListView {}

class MockCompaniesListProvider extends Mock implements CompaniesListProvider {}

void main() {
  var view = MockCompaniesListViewView();
  var mockCompaniesListProvider = MockCompaniesListProvider();

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockCompaniesListProvider);
  }

  List<CompanyListItem> _companyList = [];

  test('retrieving companies successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter =
        CompaniesListPresenter.initWith(view, mockCompaniesListProvider);

    //when
    await presenter.getCompanies();

    //then
    verifyInOrder([
      // () => view.showLoader(),
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideLoader(),
      () => view.companiesRetrievedSuccessfully(_companyList),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies failed', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    CompaniesListPresenter presenter =
        CompaniesListPresenter.initWith(view, mockCompaniesListProvider);

    //when
    await presenter.getCompanies();

    //then
    verifyInOrder([
      // () => view.showLoader(),
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideLoader(),
      () => view.companiesRetrievedError(
          "Failed To Load Companies", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('applying search successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter =
        CompaniesListPresenter.initWith(view, mockCompaniesListProvider);
    await presenter.getCompanies();

    //when
    presenter.performSearch("search");

    //then
    verifyInOrder([
      // () => view.showLoader(),
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideLoader(),
      () => view.companiesRetrievedSuccessfully(_companyList),
      () => view.companiesRetrievedSuccessfully(_companyList)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
