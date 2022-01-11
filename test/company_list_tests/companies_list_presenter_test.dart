import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/_wp_core/company_management/services/companies_list_provider.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';

class MockCompaniesListViewView extends Mock implements CompaniesListView {}

class MockCompaniesListProvider extends Mock implements CompaniesListProvider {}

class MockCompanyListItem extends Mock implements CompanyListItem {}

void main() {
  var view = MockCompaniesListViewView();
  var mockCompaniesListProvider = MockCompaniesListProvider();
  var company1 = MockCompanyListItem();
  var company2 = MockCompanyListItem();
  List<CompanyListItem> _companyList = [company1, company2];

  setUpAll(() {
    when(() => company1.name).thenReturn("test1");
    when(() => company2.name).thenReturn("test2");
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockCompaniesListProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockCompaniesListProvider);
  }

  test('retrieving companies successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(view, mockCompaniesListProvider);

    //when
    await presenter.getCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showCompanyList(_companyList),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies successfully with empty list', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(List.empty()));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(view, mockCompaniesListProvider);

    //when
    await presenter.getCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showNoCompaniesMessage(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving companies failed', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(view, mockCompaniesListProvider);

    //when
    await presenter.getCompanies();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showErrorMessage("Failed To Load Companies", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('applying search successfully', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(view, mockCompaniesListProvider);
    await presenter.getCompanies();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("test2");

    //then
    verifyInOrder([
      () => view.showCompanyList([company2]),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('applying search with empty results', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(view, mockCompaniesListProvider);
    await presenter.getCompanies();
    _resetAllMockInteractions();

    //when
    presenter.performSearch("search");

    //then
    verifyInOrder([
      () => view.showCompanyList([]),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('refresh the list of companies', () async {
    //given
    when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
    when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(_companyList));
    CompaniesListPresenter presenter = CompaniesListPresenter.initWith(view, mockCompaniesListProvider);
    await presenter.getCompanies();
    _resetAllMockInteractions();

    //when
    await presenter.refresh();

    //then
    verifyInOrder([
      () => mockCompaniesListProvider.reset(),
      () => mockCompaniesListProvider.isLoading,
      () => view.showLoader(),
      () => mockCompaniesListProvider.get(),
      () => view.showCompanyList(_companyList),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
