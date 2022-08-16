import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_shared/extensions/color_extensions.dart';
import 'package:wallpost/company_core/entities/company_group.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/services/company_list_provider.dart';
import 'package:wallpost/company_core/services/company_selector.dart';
import 'package:wallpost/company_list/models/financial_details.dart';
import 'package:wallpost/company_list/presenters/company_list_presenter.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';

import '../_mocks/mock_company.dart';
import '../_mocks/mock_current_user_provider.dart';

class MockCompaniesListView extends Mock implements CompaniesListView {}

class MockCompaniesListProvider extends Mock implements CompanyListProvider {}

class MockCompanyList extends Mock implements CompanyList {}

class MockCompanySelector extends Mock implements CompanySelector {}

class MockFinancialSummary extends Mock implements FinancialSummary {}

class MockCompanyGroup extends Mock implements CompanyGroup {}

void main() {
  late MockCompany company1;
  late MockCompany company2;
  late MockCompanyGroup companyGroup1;
  late MockCompanyGroup companyGroup2;
  late MockFinancialSummary financialSummary;
  late MockCompanyList companyList;

  var view = MockCompaniesListView();
  var mockCurrentUserProvider = MockCurrentUserProvider();
  var mockCompaniesListProvider = MockCompaniesListProvider();
  var mockCompanySelector = MockCompanySelector();
  late CompanyListPresenter presenter;

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockCurrentUserProvider);
    clearInteractions(mockCompaniesListProvider);
  }

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockCurrentUserProvider);
    verifyNoMoreInteractions(mockCompaniesListProvider);
  }

  setUp(() {
    company1 = MockCompany();
    company2 = MockCompany();
    companyGroup1 = MockCompanyGroup();
    companyGroup2 = MockCompanyGroup();
    financialSummary = MockFinancialSummary();
    companyList = MockCompanyList();

    when(() => company1.name).thenReturn("test1");
    when(() => company1.id).thenReturn("1");
    when(() => company2.name).thenReturn("test2");
    when(() => company2.id).thenReturn("2");
    when(() => companyGroup1.companyIds).thenReturn(["1"]);

    _resetAllMockInteractions();
    presenter = CompanyListPresenter.initWith(
      view,
      mockCurrentUserProvider,
      mockCompaniesListProvider,
      mockCompanySelector,
    );
  });

  group('tests for loading the data', () {
    test('retrieving companies failed', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.loadCompanies();

      //then
      verifyInOrder([
        () => mockCompaniesListProvider.isLoading,
        () => view.showLoader(),
        () => mockCompaniesListProvider.get(),
        () => view.showErrorMessage("${InvalidResponseException().userReadableMessage}\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving companies successfully with no companies', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([]);
      when(() => companyList.financialSummary).thenReturn(null);
      when(() => companyList.groups).thenReturn([]);

      //when
      await presenter.loadCompanies();

      //then
      verifyInOrder([
        () => mockCompaniesListProvider.isLoading,
        () => view.showLoader(),
        () => mockCompaniesListProvider.get(),
        () => view.showErrorMessage("There are no companies.\n\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('retrieving companies successfully ', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.financialSummary).thenReturn(null);
      when(() => companyList.groups).thenReturn([]);

      //when
      await presenter.loadCompanies();

      //then
      verifyInOrder([
        () => mockCompaniesListProvider.isLoading,
        () => view.showLoader(),
        () => mockCompaniesListProvider.get(),
        () => view.onDidLoadData(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('refreshing the list of companies', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.financialSummary).thenReturn(null);
      when(() => companyList.groups).thenReturn([]);
      await presenter.loadCompanies();
      _resetAllMockInteractions();

      //when
      await presenter.refresh();

      //then
      verifyInOrder([
        () => mockCompaniesListProvider.isLoading,
        () => view.showLoader(),
        () => mockCompaniesListProvider.get(),
        () => view.onDidLoadData(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('getting list details', () {
    test('number of items when there are no companies', () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([]);
      when(() => companyList.financialSummary).thenReturn(null);
      when(() => companyList.groups).thenReturn([]);

      //when
      await presenter.loadCompanies();

      //then
      expect(presenter.getNumberOfRows(), 0);
    });

    test('number of items when there are companies and user cannot access financial data', () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(false);
      when(() => companyList.groups).thenReturn([]);

      //when
      await presenter.loadCompanies();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
    });

    test(
        'number of items when there are companies and user has access financial data but overall financial data is null',
        () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(true);
      when(() => companyList.financialSummary).thenReturn(null);
      when(() => companyList.groups).thenReturn([]);

      //when
      await presenter.loadCompanies();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
    });

    test(
        'number of items when there are companies and user has access to financial data and overall financial data is not null',
        () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(true);
      when(() => companyList.financialSummary).thenReturn(financialSummary);
      when(() => companyList.groups).thenReturn([]);

      //when
      await presenter.loadCompanies();

      //then
      expect(presenter.getNumberOfRows(), 3);
      expect(presenter.getItemAtIndex(0), financialSummary);
      expect(presenter.getItemAtIndex(1), company1);
      expect(presenter.getItemAtIndex(2), company2);
    });

    test('number of items when group filter is selected and group financial data is null', () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(true);
      when(() => companyGroup1.financialSummary).thenReturn(null);
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);

      //when
      await presenter.loadCompanies();
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 1);
      expect(presenter.getItemAtIndex(0), company1);
    });

    test('number of items when group filter is selected and group financial data is not null', () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(true);
      when(() => companyGroup1.financialSummary).thenReturn(financialSummary);
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);

      //when
      await presenter.loadCompanies();
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), financialSummary);
      expect(presenter.getItemAtIndex(1), company1);
    });
  });

  group('tests for filtering company list', () {
    test('performing a search with no results', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => companyList.companies).thenReturn([]);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadCompanies();
      _resetAllMockInteractions();

      //when
      presenter.performSearch("non existent company id");

      //then
      verifyInOrder([() => view.updateCompanyList()]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('performing search successfully', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadCompanies();
      _resetAllMockInteractions();

      //when
      presenter.performSearch("test2");

      //then
      expect(presenter.getNumberOfRows(), 1);
      expect(presenter.getItemAtIndex(0), company2);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('selecting a company group filter shows the company list and financial summary fot that group', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(true);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyGroup1.financialSummary).thenReturn(financialSummary);
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadCompanies();
      _resetAllMockInteractions();

      //when
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), financialSummary);
      expect(presenter.getItemAtIndex(1), company1);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('clearing company group filter selection', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadCompanies();
      presenter.selectGroupAtIndex(0);
      _resetAllMockInteractions();

      //when
      presenter.clearGroupSelection();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('test applying both search and company group filter', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadCompanies();
      _resetAllMockInteractions();

      //when
      presenter.performSearch("test2");
      presenter.selectGroupAtIndex(0);

      //then
      expect(presenter.getNumberOfRows(), 0);
      verifyInOrder([
        () => view.updateCompanyList(),
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('clearing all filters', () async {
      //given
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.shouldShowFinancialData()).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.groups).thenReturn([companyGroup1, companyGroup2]);
      await presenter.loadCompanies();
      presenter.performSearch("test2");
      presenter.selectGroupAtIndex(0);
      _resetAllMockInteractions();

      //when
      presenter.clearFiltersAndUpdateViews();

      //then
      expect(presenter.getNumberOfRows(), 2);
      expect(presenter.getItemAtIndex(0), company1);
      expect(presenter.getItemAtIndex(1), company2);
      verifyInOrder([
        () => view.updateCompanyList(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for getting financial data', () {
    test('getting profit and loss financial details', () async {
      var negativeSummary = MockFinancialSummary();
      when(() => negativeSummary.profitLoss).thenReturn("USD -40");
      when(() => negativeSummary.isInProfit()).thenReturn(false);
      var details1 = presenter.getProfitLossDetails(negativeSummary);
      expect(details1.label, "Profit & Loss");
      expect(details1.value, "USD -40");
      expect(details1.textColor.isEqualTo(AppColors.failureColor), true);

      var positiveSummary = MockFinancialSummary();
      when(() => positiveSummary.profitLoss).thenReturn("USD 440");
      when(() => positiveSummary.isInProfit()).thenReturn(true);
      var details3 = presenter.getProfitLossDetails(positiveSummary);
      expect(details3.label, "Profit & Loss");
      expect(details3.value, "USD 440");
      expect(details3.textColor.isEqualTo(AppColors.successColor), true);
    });

    test('getting profit and loss financial details for header card', () async {
      var negativeSummary = MockFinancialSummary();
      when(() => negativeSummary.profitLoss).thenReturn("USD -40");
      when(() => negativeSummary.isInProfit()).thenReturn(false);
      var details1 = presenter.getProfitLossDetails(negativeSummary, isForHeaderCard: true);
      expect(details1.label, "Profit & Loss");
      expect(details1.value, "USD -40");
      expect(details1.textColor.isEqualTo(AppColors.failureColorForDarkDefaultColorBg), true);

      var positiveSummary = MockFinancialSummary();
      when(() => positiveSummary.profitLoss).thenReturn("USD 440");
      when(() => positiveSummary.isInProfit()).thenReturn(true);
      var details3 = presenter.getProfitLossDetails(positiveSummary, isForHeaderCard: true);
      expect(details3.label, "Profit & Loss");
      expect(details3.value, "USD 440");
      expect(details3.textColor.isEqualTo(AppColors.successColorForDarkDefaultColorBg), true);
    });

    test('getting available funds financial details', () async {
      var negativeSummary = MockFinancialSummary();
      when(() => negativeSummary.availableFunds).thenReturn("USD -40");
      when(() => negativeSummary.areFundsAvailable()).thenReturn(false);
      var details1 = presenter.getAvailableFundsDetails(negativeSummary);
      expect(details1.label, "Available Funds");
      expect(details1.value, "USD -40");
      expect(details1.textColor.isEqualTo(AppColors.failureColor), true);

      var positiveSummary = MockFinancialSummary();
      when(() => positiveSummary.availableFunds).thenReturn("USD 440");
      when(() => positiveSummary.areFundsAvailable()).thenReturn(true);
      var details3 = presenter.getAvailableFundsDetails(positiveSummary);
      expect(details3.label, "Available Funds");
      expect(details3.value, "USD 440");
      expect(details3.textColor.isEqualTo(AppColors.successColor), true);
    });

    test('getting overdue receivables financial details', () async {
      var negativeSummary = MockFinancialSummary();
      when(() => negativeSummary.receivableOverdue).thenReturn("USD -40");
      when(() => negativeSummary.areReceivablesOverdue()).thenReturn(false);
      var details1 = presenter.getOverdueReceivablesDetails(negativeSummary);
      expect(details1.label, "Receivables Overdue");
      expect(details1.value, "USD -40");
      expect(details1.textColor.isEqualTo(AppColors.successColor), true);

      var positiveSummary = MockFinancialSummary();
      when(() => positiveSummary.receivableOverdue).thenReturn("USD 440");
      when(() => positiveSummary.areReceivablesOverdue()).thenReturn(true);
      var details3 = presenter.getOverdueReceivablesDetails(positiveSummary);
      expect(details3.label, "Receivables Overdue");
      expect(details3.value, "USD 440");
      expect(details3.textColor.isEqualTo(AppColors.failureColor), true);
    });

    test('getting overdue payables financial details', () async {
      var negativeSummary = MockFinancialSummary();
      when(() => negativeSummary.payableOverdue).thenReturn("USD -40");
      when(() => negativeSummary.arePayablesOverdue()).thenReturn(false);
      var details1 = presenter.getOverduePayablesDetails(negativeSummary);
      expect(details1.label, "Payables Overdue");
      expect(details1.value, "USD -40");
      expect(details1.textColor.isEqualTo(AppColors.successColor), true);

      var positiveSummary = MockFinancialSummary();
      when(() => positiveSummary.payableOverdue).thenReturn("USD 440");
      when(() => positiveSummary.arePayablesOverdue()).thenReturn(true);
      var details3 = presenter.getOverduePayablesDetails(positiveSummary);
      expect(details3.label, "Payables Overdue");
      expect(details3.value, "USD 440");
      expect(details3.textColor.isEqualTo(AppColors.failureColor), true);
    });

    void _assertIsEmptyFinancialDetail(FinancialDetails financialDetails) {
      expect(financialDetails.label, "");
      expect(financialDetails.value, "");
      expect(financialDetails.textColor.alpha, 0);
    }

    test('returns empty financial data when summary is null', () async {
      var profitLossDetails = presenter.getOverduePayablesDetails(null);
      var availableFundsDetails = presenter.getOverduePayablesDetails(null);
      var receivablesOverdueDetails = presenter.getOverduePayablesDetails(null);
      var payablesOverdueDetails = presenter.getOverduePayablesDetails(null);

      _assertIsEmptyFinancialDetail(profitLossDetails);
      _assertIsEmptyFinancialDetail(availableFundsDetails);
      _assertIsEmptyFinancialDetail(receivablesOverdueDetails);
      _assertIsEmptyFinancialDetail(payablesOverdueDetails);
    });
  });

  group('tests for selecting company and viewing approvals', () {
    test('number of items when there are no companies', () async {
      when(() => mockCompaniesListProvider.isLoading).thenReturn(false);
      when(() => mockCompaniesListProvider.get()).thenAnswer((_) => Future.value(companyList));
      when(() => companyList.companies).thenReturn([company1, company2]);
      when(() => companyList.financialSummary).thenReturn(financialSummary);
      when(() => companyList.groups).thenReturn([]);
      await presenter.loadCompanies();
      _resetAllMockInteractions();

      //when
      presenter.selectCompany(company1);

      //then
      verifyInOrder([
        () => mockCompanySelector.selectCompanyForCurrentUser(company1),
        () => view.goToCompanyDetailScreen(company1),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('test going to approvals screen', () async {
      //when
      presenter.showAggregatedApprovals();

      //then
      verifyInOrder([
        () => view.goToApprovalsListScreen(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });
}
