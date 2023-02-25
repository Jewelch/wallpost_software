import 'package:flutter/foundation.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';

class SalesSummary {
  final SummaryModel? summary;
  final DataModel? data;

  const SalesSummary({this.summary, this.data});

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    try {
      return SalesSummary(
        data: json['data'] != null ? DataModel.fromJson(json['data']) : null,
        summary: json['summary'] != null ? SummaryModel.fromJson(json['summary']) : null,
      );
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw MappingException('Failed to cast $SalesSummary response. Error message - $error');
    }
  }
}

class SummaryModel {
  final String grossSales;
  final String netSales;
  final String refund;
  final String tax;
  final String discounts;
  bool summaryIsExpanded;

  SummaryModel({
    required this.grossSales,
    required this.netSales,
    required this.refund,
    required this.tax,
    required this.discounts,
    this.summaryIsExpanded = true,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) => SummaryModel(
        grossSales: json['_gross_sales'],
        netSales: json['_net_sales'],
        refund: json['_refund'],
        tax: json['_tax'],
        discounts: json['_discounts'],
        summaryIsExpanded: true,
      );
}

class DataModel {
  final List<CollectionsModel>? collections;
  final List<CollectionsModel>? categories;
  final List<OrderTypesModel>? orderTypes;

  bool collectionsAreExpanded;
  bool categoriesAreExpanded;
  bool orderTypesAreExpanded;

  DataModel({
    this.collections,
    this.categories,
    this.orderTypes,
    this.collectionsAreExpanded = true,
    this.categoriesAreExpanded = true,
    this.orderTypesAreExpanded = true,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        collections: json['collections'] == null
            ? null
            : (json['collections'] as List).map((e) => CollectionsModel.fromJson(e)).toList(),
        categories: json['categories'] == null
            ? null
            : (json['categories'] as List).map((e) => CollectionsModel.fromJson(e)).toList(),
        orderTypes: json['order_types'] == null
            ? null
            : (json['order_types'] as List).map((e) => OrderTypesModel.fromJson(e)).toList(),
        collectionsAreExpanded: true,
        categoriesAreExpanded: true,
        orderTypesAreExpanded: true,
      );
}

class CollectionsModel {
  final String item;
  final String amount;
  final String quantity;

  const CollectionsModel({
    required this.item,
    required this.amount,
    required this.quantity,
  });

  factory CollectionsModel.fromJson(Map<String, dynamic> json) => CollectionsModel(
        item: json['item'],
        amount: json['_amount'],
        quantity: json['_quantity'],
      );
}

class OrderTypesModel {
  final String item;
  final String totalSales;
  final String percent;

  const OrderTypesModel({
    required this.item,
    required this.totalSales,
    required this.percent,
  });

  factory OrderTypesModel.fromJson(Map<String, dynamic> json) => OrderTypesModel(
        item: json['item'],
        totalSales: json['_total_sales'],
        percent: json['_percent'].toString().replaceAll(('%'), ''),
      );
}
