import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class BalanceSheetData {
  final List<SheetDetailsModel> details;
  final List<AmountModel> amounts;

  const BalanceSheetData._({
    required this.details,
    required this.amounts,
  });

  factory BalanceSheetData.fromJson(List<Map<String, dynamic>> json) {
    try {
      List<SheetDetailsModel> tempDetails = [];
      List<AmountModel> tempAmounts = [];

      json.forEach((element) {
        if (element.containsKey("group"))
          tempDetails.add(SheetDetailsModel.fromJson(element));
        else
          tempAmounts.add(AmountModel.fromJson(element));
      });

      return BalanceSheetData._(
        details: tempDetails,
        amounts: tempAmounts,
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
        name = (json['name'] as String).trim(),
        amount = json['amount'],
        group = json['group'],
        children = (json['childrens'] as List? ?? []).map((e) => SheetDetailsModel.fromJson(e)).toList();
}

class AmountModel {
  final String name;
  final String amount;
  num get formattedAmount => num.parse(amount.replaceAll(",", ""));
  bool get isProfit => name.toLowerCase().contains("profit");

  AmountModel.fromJson(Map<String, dynamic> json)
      : name = (json['name'] as String).trim(),
        amount = json['amount'].toString();
}
