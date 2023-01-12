import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class ItemSalesReport {
  final num totalRevenue;
  final int totalCategories;
  final int totalItemsInAllCategories;
  final int totalOfAllItemsQuantities;
  List<CategoriesSales> categoriesSales;

  ItemSalesReport._({
    required this.totalRevenue,
    required this.totalCategories,
    required this.totalItemsInAllCategories,
    required this.totalOfAllItemsQuantities,
    required this.categoriesSales,
  });

  factory ItemSalesReport.fromJson(Map<String, dynamic> json) {
    try {
      return ItemSalesReport._(
        totalRevenue: json["totalRevenue"],
        totalCategories: json["totalCategories"],
        totalItemsInAllCategories: json["totalItemsInAllCategories"],
        totalOfAllItemsQuantities: json["totalOfAllItemsQuantities"],
        categoriesSales: json["breakdown"] == null
            ? []
            : List<CategoriesSales>.from(json["breakdown"].map((x) => CategoriesSales.fromJson(x))),
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast ItemSalesDataModel response. Error message - $error');
    }
  }
}

//TODO -rename this class
class CategoriesSales {
  final int? categoryId;
  final String categoryName;
  final int totalQuantity;
  final num totalRevenue;
  final String totalRevenueToDisplay;
  List<ItemSales> items;
  bool isExpanded;

  CategoriesSales._({
    this.categoryId,
    required this.categoryName,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.totalRevenueToDisplay,
    required this.items,
    this.isExpanded = true,
  });

  factory CategoriesSales.fromJson(Map<String, dynamic> json) => CategoriesSales._(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        totalQuantity: json["totalQuantity"],
        totalRevenue: json["totalRevenue"],
        totalRevenueToDisplay: json["totalRevenueToDisplay"],
        items: json["items"] == null ? [] : List<ItemSales>.from(json["items"].map((x) => ItemSales.fromJson(x))),
        isExpanded: true,
      );
}

class ItemSales {
  final int? itemId;
  final String itemName;
  final int qty;
  final num revenue;
  final String revenueToDisplay;

  const ItemSales._({
    this.itemId,
    required this.itemName,
    required this.qty,
    required this.revenue,
    required this.revenueToDisplay,
  });

  factory ItemSales.fromJson(Map<String, dynamic> json) => ItemSales._(
        itemId: json["itemId"],
        itemName: json["itemName"],
        qty: json["qty"],
        revenue: json["revenue"],
        revenueToDisplay: json["revenueToDisplay"],
      );
}
