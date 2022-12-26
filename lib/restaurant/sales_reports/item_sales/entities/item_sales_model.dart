import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class ItemSalesDataModel {
  final int? totalRevenue;
  final int? totalCategories;
  final int? totalItemsInAllCategories;
  final int? totalOfAllItemsQuantities;
  List<ItemSalesBreakdown>? breakdown;

  ItemSalesDataModel._({
    this.totalRevenue,
    this.totalCategories,
    this.totalItemsInAllCategories,
    this.totalOfAllItemsQuantities,
    this.breakdown,
  });

  factory ItemSalesDataModel.fromJson(Map<String, dynamic> json) {
    try {
      return ItemSalesDataModel._(
        totalRevenue: json["totalRevenue"],
        totalCategories: json["totalCategories"],
        totalItemsInAllCategories: json["totalItemsInAllCategories"],
        totalOfAllItemsQuantities: json["totalOfAllItemsQuantities"],
        breakdown: json["breakdown"] == null
            ? null
            : List<ItemSalesBreakdown>.from(
                json["breakdown"].map((x) => ItemSalesBreakdown.fromJson(x))),
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast ItemSalesDataModel response. Error message - $error');
    }
  }
}

class ItemSalesBreakdown with EquatableMixin {
  final int? categoryId;
  final String? categoryName;
  final int? totalQuantity;
  final int? totalRevenue;
  final String? totalRevenueToDisplay;
  List<ItemSales>? items;
  bool isExpanded = true;

  ItemSalesBreakdown._({
    this.categoryId,
    this.categoryName,
    this.totalQuantity,
    this.totalRevenue,
    this.totalRevenueToDisplay,
    this.items,
    required this.isExpanded,
  });

  factory ItemSalesBreakdown.fromJson(Map<String, dynamic> json) => ItemSalesBreakdown._(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        totalQuantity: json["totalQuantity"],
        totalRevenue: json["totalRevenue"],
        totalRevenueToDisplay: json["totalRevenueToDisplay"],
        items: json["items"] == null
            ? null
            : List<ItemSales>.from(json["items"].map((x) => ItemSales.fromJson(x))),
        isExpanded: true,
      );

  @override
  List<Object?> get props => [categoryId, categoryName];
}

class ItemSales {
  final int? itemId;
  final String? itemName;
  final int? qty;
  final int? revenue;
  final String? revenueToDisplay;

  const ItemSales._({
    this.itemId,
    this.itemName,
    this.qty,
    this.revenue,
    this.revenueToDisplay,
  });

  factory ItemSales.fromJson(Map<String, dynamic> json) => ItemSales._(
        itemId: json["itemId"],
        itemName: json["itemName"],
        qty: json["qty"],
        revenue: json["revenue"],
        revenueToDisplay: json["revenueToDisplay"],
      );
}
