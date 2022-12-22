import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/color_extensions.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/dashboard/finance_detail_views/ui/presenters/finance_detail_card_presenter.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';

class MockFinancialSummary extends Mock implements FinancialSummary {}

void main() {
  var company = MockCompany();
  var companyProvider = MockCompanyProvider();

  setUp(() {
    when(() => company.currency).thenReturn("USD");
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test('get currency', () async {
    var summary = MockFinancialSummary();

    when(() => summary.currency).thenReturn("USD");

    var presenter = FinanceDetailCardPresenter.initWith(summary, companyProvider);

    expect(presenter.getCurrency(), "(USD)");
  });

  test('getting profit and loss financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.profitLoss).thenReturn("-40");
    when(() => negativeSummary.isInProfit()).thenReturn(false);
    when(() => negativeSummary.currency).thenReturn("USD");
    var details1 = FinanceDetailCardPresenter.initWith(negativeSummary, companyProvider).getProfitLossDetails();
    expect(details1.label, "Profit & Loss (USD)");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.redOnDarkDefaultColorBg), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.profitLoss).thenReturn("440");
    when(() => positiveSummary.isInProfit()).thenReturn(true);
    when(() => positiveSummary.currency).thenReturn("USD");
    var details2 = FinanceDetailCardPresenter.initWith(positiveSummary, companyProvider).getProfitLossDetails();
    expect(details2.label, "Profit & Loss (USD)");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.greenOnDarkDefaultColorBg), true);
  });

  test('getting available funds financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.availableFunds).thenReturn("-40");
    when(() => negativeSummary.areFundsAvailable()).thenReturn(false);
    var details1 = FinanceDetailCardPresenter.initWith(negativeSummary, companyProvider).getAvailableFundsDetails();
    expect(details1.label, "Available\nFunds");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.redOnDarkDefaultColorBg), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.availableFunds).thenReturn("440");
    when(() => positiveSummary.areFundsAvailable()).thenReturn(true);
    var details2 = FinanceDetailCardPresenter.initWith(positiveSummary, companyProvider).getAvailableFundsDetails();
    expect(details2.label, "Available\nFunds");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.greenOnDarkDefaultColorBg), true);
  });

  test('getting overdue receivables financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.receivableOverdue).thenReturn("-40");
    when(() => negativeSummary.areReceivablesOverdue()).thenReturn(false);
    var details1 = FinanceDetailCardPresenter.initWith(negativeSummary, companyProvider).getOverdueReceivablesDetails();
    expect(details1.label, "Receivables\nOverdue");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.greenOnDarkDefaultColorBg), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.receivableOverdue).thenReturn("440");
    when(() => positiveSummary.areReceivablesOverdue()).thenReturn(true);
    var details2 = FinanceDetailCardPresenter.initWith(positiveSummary, companyProvider).getOverdueReceivablesDetails();
    expect(details2.label, "Receivables\nOverdue");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.redOnDarkDefaultColorBg), true);
  });

  test('getting overdue payables financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.payableOverdue).thenReturn("-40");
    when(() => negativeSummary.arePayablesOverdue()).thenReturn(false);
    var details1 = FinanceDetailCardPresenter.initWith(negativeSummary, companyProvider).getOverduePayablesDetails();
    expect(details1.label, "Payables\nOverdue");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.greenOnDarkDefaultColorBg), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.payableOverdue).thenReturn("440");
    when(() => positiveSummary.arePayablesOverdue()).thenReturn(true);
    var details2 = FinanceDetailCardPresenter.initWith(positiveSummary, companyProvider).getOverduePayablesDetails();
    expect(details2.label, "Payables\nOverdue");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.redOnDarkDefaultColorBg), true);
  });

  test('checking if a company is selected or not', () async {
    var selectedCompanyProvider = MockCompanyProvider();
    var presenter = FinanceDetailCardPresenter.initWith(MockFinancialSummary(), selectedCompanyProvider);

    when(() => selectedCompanyProvider.isCompanySelected()).thenReturn(false);

    expect(presenter.shouldShowDetailDisclosureIndicator(), false);

    when(() => selectedCompanyProvider.isCompanySelected()).thenReturn(true);

    expect(presenter.shouldShowDetailDisclosureIndicator(), true);
  });
}
