import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';
import 'package:wallpost/company_list/services/companies_list_provider.dart';
import 'package:wallpost/company_list/services/company_details_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';

class MockCompaniesListView extends Mock implements CompaniesListView {}

class MockCompaniesListProvider extends Mock implements CompaniesListProvider {}

class MockCompanyListItem extends Mock implements CompanyListItem {}

class MockCompanyDetailsProvider extends Mock implements CompanyDetailsProvider {}

class MockUserRemover extends Mock implements UserRemover {}

void main() {
  var view = MockCompaniesListView();
  var mockCompaniesListProvider = MockCompaniesListProvider();
  var mockCompanyDetailsProvider = MockCompanyDetailsProvider();
  late CompaniesListPresenter presenter;

  var company1 = MockCompanyListItem();
  var company2 = MockCompanyListItem();
  List<CompanyListItem> _companyList = [company1, company2];

  setUpAll(() {
    when(() => company1.name).thenReturn("test1");
    when(() => company1.id).thenReturn("id1");
    when(() => company2.name).thenReturn("test2");
    when(() => company2.id).thenReturn("id2");
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockCompaniesListProvider);
    verifyNoMoreInteractions(mockCompanyDetailsProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockCompaniesListProvider);
    clearInteractions(mockCompanyDetailsProvider);
  }

  setUp(() {
    presenter = CompaniesListPresenter.initWith(
      view,
      mockCompaniesListProvider,
      mockCompanyDetailsProvider,
    );
    _resetAllMockInteractions();
  });

  test('retrieving companies successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));

    //when
    await presenter.loadCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showSearchBar(),
      () => view.showCompanyList([company1, company2]),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies successfully with empty list', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(List.empty()));

    //when
    await presenter.loadCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideSearchBar(),
      () => view.showNoCompaniesMessage("There are no companies.\n\nTap here to reload"),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies failed', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.hideSearchBar(),
      () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      () => view.hideLoader(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('performing search successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
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
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value([]));
    await presenter.loadCompanies();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("non existent company id");

    //then
    verifyInOrder([
      () => view.showNoSearchResultsMessage("There are no companies for the  given search criteria."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('test search text is reset when search bar is hidden', () async {
    //given
    //step 1 - load companies
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    //step 2 - perform search
    presenter.performSearch("c1");

    //when
    when(() => mockCompaniesListProvider.get())
        .thenAnswer((realInvocation) => Future.error(InvalidResponseException()));
    await presenter.loadCompanies();

    //then
    expect(presenter.getSearchText(), "");
  });

  test('refresh the list of companies', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));

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
      () => view.showCompanyList([company1, company2]),
      () => view.hideLoader()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('select company from company list successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    when(() => mockCompanyDetailsProvider.getCompanyDetails(any())).thenAnswer((_) async {});
    await presenter.loadCompanies();
    _resetAllMockInteractions();

    //when
    await presenter.selectCompanyAtIndex(0);

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => mockCompanyDetailsProvider.getCompanyDetails("id1"),
      () => view.hideLoader(),
      () => view.onCompanyDetailsLoadedSuccessfully()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('select company from company list failed', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    when(() => mockCompanyDetailsProvider.getCompanyDetails(any())).thenAnswer((invocation) => Future.error(InvalidResponseException()));
    await presenter.loadCompanies();
    _resetAllMockInteractions();

    //when
    await presenter.selectCompanyAtIndex(0);

    //then
    verifyInOrder([
      () => view.showLoader(),
      () => mockCompanyDetailsProvider.getCompanyDetails("id1"),
      () => view.hideLoader(),
      () => view.onCompanyDetailsLoadingFailed(
          'Failed To load company details', InvalidResponseException().userReadableMessage)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('test logout', () async {
    presenter.logout();

    //then
    verifyInOrder([
      () => view.showLogoutAlert("Logout", "Are you sure you want to log out?"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
