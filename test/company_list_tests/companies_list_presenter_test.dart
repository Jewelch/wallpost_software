import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/company_details_provider.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';

import '../_mocks/mock_company.dart';

class MockCompaniesListViewView extends Mock implements CompaniesListView {}

class MockCompaniesListProvider extends Mock implements CompaniesListProvider {}

class MockCompanyListItem extends Mock implements CompanyListItem {}

class MockCompanyDetailsProvider extends Mock
    implements CompanyDetailsProvider {}

class MockSelectedCompanyProvider extends Mock
    implements SelectedCompanyProvider {}

void main() {
  var view = MockCompaniesListViewView();
  var mockCompaniesListProvider = MockCompaniesListProvider();
  var mockCompanyDetailsProvider = MockCompanyDetailsProvider();
  var mockSelectedCompanyProvider = MockSelectedCompanyProvider();
  var company1 = MockCompanyListItem();
  var company2 = MockCompanyListItem();
  var mockCompany = MockCompany();
  List<CompanyListItem> _companyList = [company1, company2];

  setUpAll(() {
    when(() => company1.name).thenReturn("test1");
    when(() => company1.id).thenReturn("id1");
    when(() => company2.name).thenReturn("test2");
    when(() => company2.id).thenReturn("id2");
    when(() => mockCompany.id).thenReturn("id1");
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockCompaniesListProvider);
    verifyNoMoreInteractions(mockCompanyDetailsProvider);
    verifyNoMoreInteractions(mockSelectedCompanyProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockCompaniesListProvider);
    clearInteractions(mockCompanyDetailsProvider);
    clearInteractions(mockSelectedCompanyProvider);
  }

  test('retrieving companies successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);

    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(_companyList));
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser())
        .thenAnswer((_) => mockCompany);
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);

    //when
    await presenter.loadCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showSearchBar(),
      () => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser(),
      () => view.showSelectedCompany(company1),
      () => view.showCompanyList([company2]),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies successfully with empty list', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(List.empty()));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);

    //when
    await presenter.loadCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideSearchBar(),
      () => view.showNoCompaniesMessage(
          "There are no companies.\n\nTap here to reload"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies failed', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);

    //when
    await presenter.loadCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideSearchBar(),
      () => view.showErrorMessage(
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('performing search successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser())
        .thenReturn(mockCompany);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);
    await presenter.loadCompanies();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("test2");

    //then
    verifyInOrder([
      () => view.showCompanyList([company2]),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('performing a search with no results', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value([]));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);
    await presenter.loadCompanies();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("non existent company id");

    //then
    verifyInOrder([
      () => view.showNoSearchResultsMessage(
          "There are no companies for the  given search criteria."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('test search text is reset when search bar is hidden', () async {
    //given
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);
    //step 1 - load companies
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(_companyList));
    //step 2 - perform search
    presenter.performSearch("c1");

    //when
    when(() => mockCompaniesListProvider.get()).thenAnswer(
        (realInvocation) => Future.error(InvalidResponseException()));
    await presenter.loadCompanies();

    //then
    expect(presenter.getSearchText(), "");
  });

  test('refresh the list of companies', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((_) => Future.value(_companyList));
    when(() => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser())
        .thenReturn(mockCompany);

    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(
        view,
        mockCompaniesListProvider,
        mockCompanyDetailsProvider,
        mockSelectedCompanyProvider);
    await presenter.loadCompanies();
    _resetAllMockInteractions();

    //when
    await presenter.refresh();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.reset(),
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showSearchBar(),
      () => mockSelectedCompanyProvider.getSelectedCompanyForCurrentUser(),
      () => view.showSelectedCompany(company1),
      () => view.showCompanyList([company2]),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
