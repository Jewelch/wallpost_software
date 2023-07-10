import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class ProfitsLossesReport {
  final ProfitLossItem revenue;
  final ProfitLossItem costOfSales;
  final ProfitLossItem grossProfit;
  final ProfitLossItem expense;
  final ProfitLossItem operatingProfit;
  final ProfitLossItem otherExpenses;
  final ProfitLossItem otherRevenues;
  final ProfitLossItem netProfit;

  ProfitsLossesReport._({
    required this.revenue,
    required this.costOfSales,
    required this.grossProfit,
    required this.expense,
    required this.operatingProfit,
    required this.otherExpenses,
    required this.otherRevenues,
    required this.netProfit,
  });

  factory ProfitsLossesReport.fromJson(Map<String, dynamic> json) {
    try {
      print(json);
      return ProfitsLossesReport._(
        revenue: ProfitLossItem.fromJsonWithName('Revenue', json['Revenue']),
        costOfSales: ProfitLossItem.fromJsonWithName('Cost of Sales', json['Cost of Sales']),
        grossProfit: ProfitLossItem.fromJsonWithName('Gross Profit', json['Gross Profit']),
        expense: ProfitLossItem.fromJsonWithName('Expense', json['Expense']),
        operatingProfit: ProfitLossItem.fromJsonWithName('Operating Profit', json['Operating Profit']),
        otherExpenses: ProfitLossItem.fromJsonWithName('Other Expenses', json['Other Expenses']),
        otherRevenues: ProfitLossItem.fromJsonWithName('Other Revenues', json['Other Revenues']),
        netProfit: ProfitLossItem.fromJsonWithName('Net Profit', json['Net Profit']),
      );
    } catch (error, stackTrace) {
      print(error);
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast ProfitsLossesReport response. Error message - $error');
    }
  }
}

class ProfitLossItem {
  final String name;
  final String amount;
  num get formattedAmount => num.parse(amount.replaceAll(",", "."));
  final List<ProfitLossItem> children;

  ProfitLossItem.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        amount = json['amount'].toString(),
        children = (json['childrens'] as List? ?? []).map((e) => ProfitLossItem.fromJson(e)).toList();

  ProfitLossItem.fromJsonWithName(this.name, Map<String, dynamic> json)
      : amount = json['amounts'].toString(),
        children = (json['childrens'] as List? ?? []).map((e) => ProfitLossItem.fromJson(e)).toList();
}
