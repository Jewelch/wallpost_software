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
    when(() => negativeSummary.currency).thenReturn("USD");
    when(() => negativeSummary.profitLoss).thenReturn("-40");
    when(() => negativeSummary.isInProfit()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getProfitLossDetails();
    expect(details1.label, "Profit\nand Loss");
    expect(details1.value, "USD -40");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.currency).thenReturn("USD");
    when(() => positiveSummary.profitLoss).thenReturn("440");
    when(() => positiveSummary.isInProfit()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getProfitLossDetails();
    expect(details2.label, "Profit\nand Loss");
    expect(details2.value, "USD 440");
    expect(details2.valueColor.isEqualTo(AppColors.green), true);
  });

  test('getting available funds financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.currency).thenReturn("USD");
    when(() => negativeSummary.availableFunds).thenReturn("-40");
    when(() => negativeSummary.areFundsAvailable()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getAvailableFundsDetails();
    expect(details1.label, "Available\nFunds");
    expect(details1.value, "USD -40");
    expect(details1.valueColor.isEqualTo(AppColors.red), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.currency).thenReturn("USD");
    when(() => positiveSummary.availableFunds).thenReturn("440");
    when(() => positiveSummary.areFundsAvailable()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getAvailableFundsDetails();
    expect(details2.label, "Available\nFunds");
    expect(details2.value, "USD 440");
    expect(details2.valueColor.isEqualTo(AppColors.green), true);
  });

  test('getting overdue receivables financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.currency).thenReturn("USD");
    when(() => negativeSummary.receivableOverdue).thenReturn("-40");
    when(() => negativeSummary.areReceivablesOverdue()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getOverdueReceivablesDetails();
    expect(details1.label, "Receivables\nOverdue");
    expect(details1.value, "USD -40");
    expect(details1.valueColor.isEqualTo(AppColors.green), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.currency).thenReturn("USD");
    when(() => positiveSummary.receivableOverdue).thenReturn("440");
    when(() => positiveSummary.areReceivablesOverdue()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getOverdueReceivablesDetails();
    expect(details2.label, "Receivables\nOverdue");
    expect(details2.value, "USD 440");
    expect(details2.valueColor.isEqualTo(AppColors.red), true);
  });

  test('getting overdue payables financial details', () async {
    var negativeSummary = MockFinancialSummary();
    when(() => negativeSummary.currency).thenReturn("USD");
    when(() => negativeSummary.payableOverdue).thenReturn("-40");
    when(() => negativeSummary.arePayablesOverdue()).thenReturn(false);
    var details1 = FinanceDetailListItemPresenter(negativeSummary).getOverduePayablesDetails();
    expect(details1.label, "Payables\nOverdue");
    expect(details1.value, "USD -40");
    expect(details1.valueColor.isEqualTo(AppColors.green), true);

    var positiveSummary = MockFinancialSummary();
    when(() => positiveSummary.currency).thenReturn("USD");
    when(() => positiveSummary.payableOverdue).thenReturn("440");
    when(() => positiveSummary.arePayablesOverdue()).thenReturn(true);
    var details2 = FinanceDetailListItemPresenter(positiveSummary).getOverduePayablesDetails();
    expect(details2.label, "Payables\nOverdue");
    expect(details2.value, "USD 440");
    expect(details2.valueColor.isEqualTo(AppColors.red), true);
  });
}
