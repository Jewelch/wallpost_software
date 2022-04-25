// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
// import 'package:wallpost/company_core/entities/company_group.dart';
// import 'package:wallpost/company_core/entities/company_list.dart';
// import 'package:wallpost/company_core/entities/company_list_item.dart';
// import 'package:wallpost/company_core/entities/financial_summary.dart';
// import 'package:wallpost/company_core/services/company_details_provider.dart';
// import 'package:wallpost/company_core/services/company_list_provider.dart';
// import 'package:wallpost/company_list/presenters/company_list_presenter.dart';
// import 'package:wallpost/company_list/view_contracts/company_list_view.dart';
//
// import '../../_mocks/mock_company.dart';
// import '../../_mocks/mock_current_user_provider.dart';
// import '../../_mocks/mock_user.dart';
//
// class MockCompaniesListView extends Mock implements CompaniesListView {}
//
// class MockCompaniesListProvider extends Mock implements CompanyListProvider {}
//
// class MockCompanyList extends Mock implements CompanyList {}
//
// class MockCompanyListItem extends Mock implements CompanyListItem {}
//
// class MockFinancialSummary extends Mock implements FinancialSummary {}
//
// class MockCompanyGroup extends Mock implements CompanyGroup {}
//
// class MockCompanyDetailsProvider extends Mock
//     implements CompanyDetailsProvider {}
//
// void main() {
//   var view = MockCompaniesListView();
//   var mockCurrentUserProvider = MockCurrentUserProvider();
//   var mockCompaniesListProvider = MockCompaniesListProvider();
//   var mockCompanyDetailsProvider = MockCompanyDetailsProvider();
//   late CompanyListPresenter presenter;
//
//   var companyList = MockCompanyList();
//   var company1 = MockCompanyListItem();
//   var company2 = MockCompanyListItem();
//   var companyGroup = MockCompanyGroup();
//   var companyGroup2 = MockCompanyGroup();
//   var mockCompany = MockCompany();
//   List<CompanyListItem> _companyList = [company1, company2];
//   List<CompanyGroup> _companyGroupList = [companyGroup, companyGroup2];
//   var financialSummary = MockFinancialSummary();
//
//   setUpAll(() {
//     when(() => company1.name).thenReturn("test1");
//     when(() => company1.id).thenReturn("1");
//     when(() => company1.approvalCount).thenReturn(1);
//     when(() => company2.name).thenReturn("test2");
//     when(() => company2.id).thenReturn("2");
//     when(() => company2.approvalCount).thenReturn(2);
//     when(() => companyGroup.companyIds).thenReturn(["1"]);
//     when(() => mockCompany.id).thenReturn("id1");
//     when(() => financialSummary.payableOverdue).thenReturn("po");
//     when(() => financialSummary.receivableOverdue).thenReturn("ro");
//     when(() => financialSummary.cashAvailability).thenReturn("ca");
//     when(() => financialSummary.profitLoss).thenReturn("pl");
//   });
//
//   void _resetAllMockInteractions() {
//     clearInteractions(view);
//     clearInteractions(mockCurrentUserProvider);
//     clearInteractions(mockCompaniesListProvider);
//     clearInteractions(mockCompanyDetailsProvider);
//   }
//
//   void _verifyNoMoreInteractionsOnAllMocks() {
//     verifyNoMoreInteractions(view);
//     verifyNoMoreInteractions(mockCurrentUserProvider);
//     verifyNoMoreInteractions(mockCompaniesListProvider);
//     verifyNoMoreInteractions(mockCompanyDetailsProvider);
//   }
//
//   setUp(() {
//     _resetAllMockInteractions();
//     presenter = CompanyListPresenter.initWith(
//       view,
//       mockCurrentUserProvider,
//       mockCompaniesListProvider,
//       mockCompanyDetailsProvider,
//     );
//   });
//
//   test('load user details', () async {
//     var mockUser = MockUser();
//     when(() => mockUser.profileImageUrl).thenReturn("someUrl.com");
//     when(() => mockCurrentUserProvider.getCurrentUser()).thenReturn(mockUser);
//
//     presenter.loadUserDetails();
//
//     verifyInOrder([
//       () => mockCurrentUserProvider.getCurrentUser(),
//       () => view.showProfileImage("someUrl.com"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('retrieving companies failed', () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get()).thenAnswer(
//       (realInvocation) => Future.error(InvalidResponseException()),
//     );
//
//     //when
//     await presenter.loadCompanies();
//
//     //then
//     verifyInOrder([
//       () => mockCompaniesListProvider.isLoading,
//       () => view.showLoader(),
//       () => mockCompaniesListProvider.get(),
//       () => view.hideLoader(),
//       () => view.hideSearchBar(),
//       () => view.hideCompanyGroupsFilter(),
//       () => view.hideFinancialSummary(),
//       () => view.hideCompanyList(),
//       () => view.showErrorMessage(
//           "${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       'retrieving companies successfully with no companies, no financial data, and no groups',
//       () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn([]);
//     when(() => companyList.financialSummary).thenReturn(null);
//     when(() => companyList.groups).thenReturn([]);
//
//     //when
//     await presenter.loadCompanies();
//
//     //then
//     verifyInOrder([
//       () => mockCompaniesListProvider.isLoading,
//       () => view.showLoader(),
//       () => mockCompaniesListProvider.get(),
//       () => view.hideLoader(),
//       () => view.hideSearchBar(),
//       () => view.hideCompanyGroupsFilter(),
//       () => view.hideFinancialSummary(),
//       () => view.hideCompanyList(),
//       () => view
//           .showErrorMessage("There are no companies.\n\nTap here to reload."),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       'retrieving companies successfully with no financial summary and no company groups ',
//       () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => companyList.financialSummary).thenReturn(null);
//     when(() => companyList.groups).thenReturn([]);
//
//     //when
//     await presenter.loadCompanies();
//
//     //then
//     verifyInOrder([
//       () => mockCompaniesListProvider.isLoading,
//       () => view.showLoader(),
//       () => mockCompaniesListProvider.get(),
//       () => view.hideLoader(),
//       () => view.showSearchBar(),
//       () => view.hideCompanyGroupsFilter(),
//       () => view.hideFinancialSummary(),
//       () => view.showCompanyList(_companyList),
//       () => view.showApprovalCount(3)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('retrieving companies successfully with no financial summary', () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => companyList.financialSummary).thenReturn(null);
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//
//     //when
//     await presenter.loadCompanies();
//
//     //then
//     verifyInOrder([
//       () => mockCompaniesListProvider.isLoading,
//       () => view.showLoader(),
//       () => mockCompaniesListProvider.get(),
//       () => view.hideLoader(),
//       () => view.showSearchBar(),
//       () => view.showCompanyGroupsFilter(_companyGroupList),
//       () => view.hideFinancialSummary(),
//       () => view.showCompanyList(_companyList),
//       () => view.showApprovalCount(3)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       'retrieving companies successfully with financial summary and company groups',
//       () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => companyList.financialSummary).thenReturn(financialSummary);
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//
//     //when
//     await presenter.loadCompanies();
//
//     //then
//     verifyInOrder([
//       () => mockCompaniesListProvider.isLoading,
//       () => view.showLoader(),
//       () => mockCompaniesListProvider.get(),
//       () => view.hideLoader(),
//       () => view.showSearchBar(),
//       () => view.showCompanyGroupsFilter(_companyGroupList),
//       () => view.showFinancialSummary(financialSummary),
//       () => view.showCompanyList(_companyList),
//       () => view.showApprovalCount(3)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('performing search successfully', () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//     await presenter.loadCompanies();
//     _resetAllMockInteractions();
//
//     //when
//     presenter.performSearch("test2");
//
//     //then
//     verifyInOrder([
//       () => view.showCompanyList([company2]),
//       () => view.showApprovalCount(2)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('performing a search with no results', () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => companyList.companies).thenReturn([]);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//     await presenter.loadCompanies();
//     _resetAllMockInteractions();
//
//     //when
//     presenter.performSearch("non existent company id");
//
//     //then
//     verifyInOrder([
//       () => view.showNoSearchResultsMessage(
//           "There are no companies for the  given search criteria."),
//       () => view.showApprovalCount(null)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('test search text is reset when search bar is hidden', () async {
//     //given
//     //step 1 - load companies
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     //step 2 - perform search
//     presenter.performSearch("c1");
//
//     //when - hide search bar by causing an error
//     when(() => mockCompaniesListProvider.get()).thenAnswer(
//         (realInvocation) => Future.error(InvalidResponseException()));
//     await presenter.loadCompanies();
//
//     //then
//     expect(presenter.getSearchText(), "");
//   });
//
//   test('refreshing the list of companies', () async {
//     //given
//
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get()).thenAnswer(
//       (realInvocation) => Future.error(InvalidResponseException()),
//     );
//
//     await presenter.loadCompanies();
//     _resetAllMockInteractions();
//
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => companyList.financialSummary).thenReturn(financialSummary);
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//
//     //when
//     await presenter.refresh();
//
//     //then
//     verifyInOrder([
//       () => view.hideFinancialSummary(),
//       () => view.showAppBar(false),
//       () => view.selectGroupItem(null),
//       () => mockCompaniesListProvider.reset(),
//       () => view.showApprovalCount(null),
//       () => mockCompaniesListProvider.isLoading,
//       () => view.showLoader(),
//       () => mockCompaniesListProvider.get(),
//       () => view.hideLoader(),
//       () => view.showSearchBar(),
//       () => view.showCompanyGroupsFilter(_companyGroupList),
//       () => view.showFinancialSummary(financialSummary),
//       () => view.showCompanyList(_companyList),
//       () => view.showApprovalCount(3)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('select company from company list failed', () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//     when(() => mockCompanyDetailsProvider.getCompanyDetails("1"))
//         .thenAnswer((invocation) => Future.error(InvalidResponseException()));
//
//     await presenter.loadCompanies();
//     _resetAllMockInteractions();
//
//     //when
//     await presenter.selectCompanyAtIndex(0);
//
//     //then
//     verifyInOrder([
//       () => view.showLoader(),
//       () => mockCompanyDetailsProvider.getCompanyDetails("1"),
//       () => view.hideLoader(),
//       () => view.onCompanyDetailsLoadingFailed('Failed To load company details',
//           InvalidResponseException().userReadableMessage)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('select company from company list successfully', () async {
//     //given
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//     when(() => mockCompanyDetailsProvider.getCompanyDetails("1"))
//         .thenAnswer((invocation) => Future.value(null));
//
//     await presenter.loadCompanies();
//     _resetAllMockInteractions();
//
//     //when
//     await presenter.selectCompanyAtIndex(0);
//
//     //then
//     verifyInOrder([
//       () => view.showLoader(),
//       () => mockCompanyDetailsProvider.getCompanyDetails("1"),
//       () => view.hideLoader(),
//       () => view.goToCompanyDetailScreen()
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('select company group from companiesGroup list with no search',
//       () async {
//     //given
//     //step 1 - load companies
//     when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
//     when(() => companyList.companies).thenReturn(_companyList);
//     when(() => mockCompaniesListProvider.get())
//         .thenAnswer((_) => Future.value(companyList));
//     when(() => companyList.groups).thenReturn(_companyGroupList);
//
//     await presenter.loadCompanies();
//     _resetAllMockInteractions();
//
//     //step 2 - select 1st group
//     presenter.showGroup(0);
//
//     verifyInOrder([
//       () => view.showFinancialSummary(_companyGroupList[0].financialSummary!),
//       () => view.showCompanyList([_companyList.first]),
//           () => view.showApprovalCount(1)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('test logout', () async {
//     presenter.logout();
//
//     //then
//     verifyInOrder([
//       () => view.showLogoutAlert("Logout", "Are you sure you want to log out?"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
// }
