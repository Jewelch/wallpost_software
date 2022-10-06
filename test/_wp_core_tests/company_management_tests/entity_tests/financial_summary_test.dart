import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';

main() {
  test("profit and loss status", () {
    var profitMap = {
      "currency": "USD",
      "cashAvailability": "-17.6M",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "623.5M"
    };
    var profitSummary = FinancialSummary.fromJson(profitMap);
    expect(profitSummary.isInProfit(), true);

    var zeroProfitMap = {
      "currency": "USD",
      "cashAvailability": "-17.6M",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "0"
    };
    var zeroProfitSummary = FinancialSummary.fromJson(zeroProfitMap);
    expect(zeroProfitSummary.isInProfit(), true);

    var lossMap = {
      "currency": "USD",
      "cashAvailability": "-17.6M",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "-23"
    };
    var lossSummary = FinancialSummary.fromJson(lossMap);
    expect(lossSummary.isInProfit(), false);
  });

  test("available funds status", () {
    var fundsAvailableMap = {
      "currency": "USD",
      "cashAvailability": "17.6M",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "623.5M"
    };
    var fundsAvailableSummary = FinancialSummary.fromJson(fundsAvailableMap);
    expect(fundsAvailableSummary.areFundsAvailable(), true);

    var zeroFundsMap = {
      "currency": "USD",
      "cashAvailability": "0",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "-23"
    };
    var zeroFundsSummary = FinancialSummary.fromJson(zeroFundsMap);
    expect(zeroFundsSummary.areFundsAvailable(), false);

    var negativeFundsMap = {
      "currency": "USD",
      "cashAvailability": "-30",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "-23"
    };
    var negativeFundsSummary = FinancialSummary.fromJson(negativeFundsMap);
    expect(negativeFundsSummary.areFundsAvailable(), false);
  });

  test("overdue receivables status", () {
    var overdueReceivablesMap = {
      "currency": "USD",
      "cashAvailability": "17.6M",
      "receivableOverdue": "25B",
      "payableOverdue": "1.7M",
      "profitLoss": "623.5M"
    };
    var overdueReceivablesSummary = FinancialSummary.fromJson(overdueReceivablesMap);
    expect(overdueReceivablesSummary.areReceivablesOverdue(), true);

    var zeroReceivablesMap = {
      "currency": "USD",
      "cashAvailability": "0",
      "receivableOverdue": "0",
      "payableOverdue": "1.7M",
      "profitLoss": "-23"
    };
    var zeroReceivablesSummary = FinancialSummary.fromJson(zeroReceivablesMap);
    expect(zeroReceivablesSummary.areReceivablesOverdue(), false);

    var negativeReceivablesMap = {
      "currency": "USD",
      "cashAvailability": "-30",
      "receivableOverdue": "-5B",
      "payableOverdue": "1.7M",
      "profitLoss": "-23"
    };
    var negativeReceivablesSummary = FinancialSummary.fromJson(negativeReceivablesMap);
    expect(negativeReceivablesSummary.areReceivablesOverdue(), false);
  });

  test("overdue payables status", () {
    var overduePayablesMap = {
      "currency": "USD",
      "cashAvailability": "17.6M",
      "receivableOverdue": "-25B",
      "payableOverdue": "1.7M",
      "profitLoss": "623.5M"
    };
    var overduePayablesSummary = FinancialSummary.fromJson(overduePayablesMap);
    expect(overduePayablesSummary.arePayablesOverdue(), true);

    var zeroPayablesMap = {
      "currency": "USD",
      "cashAvailability": "0",
      "receivableOverdue": "30",
      "payableOverdue": "0",
      "profitLoss": "-23"
    };
    var zeroPayablesSummary = FinancialSummary.fromJson(zeroPayablesMap);
    expect(zeroPayablesSummary.arePayablesOverdue(), false);

    var negativePayablesMap = {
      "currency": "USD",
      "cashAvailability": "30",
      "receivableOverdue": "5B",
      "payableOverdue": "-1.7M",
      "profitLoss": "23"
    };
    var negativePayablesSummary = FinancialSummary.fromJson(negativePayablesMap);
    expect(negativePayablesSummary.arePayablesOverdue(), false);
  });

  //tests for getters

  test("getters", () {
    var summaryMap = {
      "currency": "USD",
      "cashAvailability": "17.6M",
      "receivableOverdue": "-25B",
      "payableOverdue": "1.7M",
      "profitLoss": "623.5M"
    };

    var summary = FinancialSummary.fromJson(summaryMap);

    expect(summary.currency, "USD");
    expect(summary.profitLoss, "623.5M");
    expect(summary.availableFunds, "17.6M");
    expect(summary.receivableOverdue, "-25B");
    expect(summary.payableOverdue, "1.7M");
  });
}
