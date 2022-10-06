import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/color_extensions.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/dashboard/finance_detail_views/ui/presenters/finance_detail_list_item_presenter.dart';

class MockFinancialSummary extends Mock implements FinancialSummary {}

void main() {
  test('getting profit and loss financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.profitLoss).thenReturn("-40");
    when(() => negativeSummary.isInProfit()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getProfitLossDetails();
    expect(details1.label, "Profit & Loss");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.profitLoss).thenReturn("440");
    when(() => positiveSummary.isInProfit()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getProfitLossDetails();
    expect(details2.label, "Profit & Loss");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.green), true);
  });

  test('getting available funds financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.availableFunds).thenReturn("-40");
    when(() => negativeSummary.areFundsAvailable()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getAvailableFundsDetails();
    expect(details1.label, "Available Funds");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.availableFunds).thenReturn("440");
    when(() => positiveSummary.areFundsAvailable()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getAvailableFundsDetails();
    expect(details2.label, "Available Funds");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.green), true);
  });

  test('getting overdue receivables financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.receivableOverdue).thenReturn("-40");
    when(() => negativeSummary.areReceivablesOverdue()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getOverdueReceivablesDetails();
    expect(details1.label, "Receivables Overdue");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.green), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.receivableOverdue).thenReturn("440");
    when(() => positiveSummary.areReceivablesOverdue()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getOverdueReceivablesDetails();
    expect(details2.label, "Receivables Overdue");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.red), true);
  });

  test('getting overdue payables financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.payableOverdue).thenReturn("-40");
    when(() => negativeSummary.arePayablesOverdue()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getOverduePayablesDetails();
    expect(details1.label, "Payables Overdue");
    expect(details1.value, "-40");
    expect(details1.valueColor.isEqualTo(AppColors.green), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.payableOverdue).thenReturn("440");
    when(() => positiveSummary.arePayablesOverdue()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getOverduePayablesDetails();
    expect(details2.label, "Payables Overdue");
    expect(details2.value, "440");
    expect(details2.valueColor.isEqualTo(AppColors.red), true);
  });
}
