import '../../../../_shared/exceptions/mapping_exception.dart';
import '../../../../_shared/json_serialization_base/json_initializable.dart';

class BalanceSheetData extends JSONInitializable {
  SheetDetailsModel? assets;
  SheetDetailsModel? liabilities;
  SheetDetailsModel? equity;
  AmountModel? totalAssets;
  AmountModel? totalLiabilityAndOwnersEquity;
  AmountModel? profitLossAccount;
  AmountModel? difference;

  BalanceSheetData.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    try {
      assets = json['Assets'] != null ? new SheetDetailsModel.fromJson(json['Assets']) : null;
      liabilities = json['Liabilities'] != null ? new SheetDetailsModel.fromJson(json['Liabilities']) : null;
      equity = json['Equity'] != null ? new SheetDetailsModel.fromJson(json['Equity']) : null;
      totalAssets = json['Total Assets'] != null ? new AmountModel.fromJson(json['Total Assets']) : null;
      totalLiabilityAndOwnersEquity = json['Total Liability and Owners Equity'] != null
          ? new AmountModel.fromJson(json['Total Liability and Owners Equity'])
          : null;
      profitLossAccount =
          json['Profit & Loss Account'] != null ? new AmountModel.fromJson(json['Profit & Loss Account']) : null;
      difference = json['Difference'] != null ? new AmountModel.fromJson(json['Difference']) : null;
    } catch (e) {
      throw MappingException('Failed to cast BalanceSheetData response. Error message - $e');
    }
  }
}

class SheetDetailsModel {
  String? id;
  String? name;
  int? parentId;
  String? groupName;
  int? level;
  String? amount;
  bool? group;
  List<SheetDetailsModel>? children;

  SheetDetailsModel(
      {this.id, this.name, this.parentId, this.groupName, this.level, this.amount, this.group, this.children});

  SheetDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    parentId = json['parent_id'];
    groupName = json['group_name'];
    level = json['level'];
    amount = json['amount'];
    group = json['group'];
    if (json['childrens'] != null) {
      children = <SheetDetailsModel>[];
      json['childrens'].forEach((v) {
        children!.add(new SheetDetailsModel.fromJson(v));
      });
    }
  }
}

class AmountModel {
  String? name;
  String? amount;
  double? dAmount;

  AmountModel({this.name, this.amount, this.dAmount});

  AmountModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
    dAmount = json['_amount'];
  }
}
