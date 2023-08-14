import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class BalanceSheetData {
  SheetDetailsModel assets;
  SheetDetailsModel liabilities;
  SheetDetailsModel equity;
  AmountModel totalAssets;
  AmountModel totalLiabilityAndOwnersEquity;
  AmountModel profitLossAccount;
  AmountModel difference;

  BalanceSheetData._({
    required this.assets,
    required this.liabilities,
    required this.equity,
    required this.totalAssets,
    required this.totalLiabilityAndOwnersEquity,
    required this.profitLossAccount,
    required this.difference,
  });

  factory BalanceSheetData.fromJson(Map<String, dynamic> json) {
    try {
      return BalanceSheetData._(
        assets: SheetDetailsModel.fromJson(json['Assets']),
        liabilities: SheetDetailsModel.fromJson(json['Liabilities']),
        equity: SheetDetailsModel.fromJson(json['Equity']),
        totalAssets: AmountModel.fromJson(json['Total Assets']),
        totalLiabilityAndOwnersEquity: AmountModel.fromJson(json['Total Liability and Owners Equity']),
        profitLossAccount: AmountModel.fromJson(json['Profit & Loss Account']),
        difference: AmountModel.fromJson(json['Difference']),
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast BalanceSheetData response. Error message - $error');
    }
  }
}

class SheetDetailsModel {
  final String id;
  final String name;
  final String amount;
  num get formattedAmount => num.parse(amount.replaceAll(",", ""));
  final bool group;
  final List<SheetDetailsModel> children;

  SheetDetailsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        amount = json['amount'],
        group = json['group'],
        children = (json['childrens'] as List? ?? []).map((e) => SheetDetailsModel.fromJson(e)).toList();
}

class AmountModel {
  final String name;
  final String amount;
  num get formattedAmount => num.parse(amount.replaceAll(",", ""));

  AmountModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        amount = json['amount'].toString();
}
