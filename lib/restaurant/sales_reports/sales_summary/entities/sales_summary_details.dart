

class SalesSummaryDetails {
  final List<SalesSummaryItem> collections;
  final List<SalesSummaryItem> categories;
  final List<SaleSummaryOrderType> orderTypes;

  SalesSummaryDetails._({
    required this.collections,
    required this.categories,
    required this.orderTypes,
  });

  factory SalesSummaryDetails.fromJson(Map<String, dynamic> json) => SalesSummaryDetails._(
    collections: (json['collections'] as List).map((e) => SalesSummaryItem.fromJson(e)).toList(),
    categories: (json['categories'] as List).map((e) => SalesSummaryItem.fromJson(e)).toList(),
    orderTypes: (json['order_types'] as List).map((e) => SaleSummaryOrderType.fromJson(e)).toList(),
  );
}

class SalesSummaryItem {
  final String item;
  final String amount;
  final String quantity;

  const SalesSummaryItem({
    required this.item,
    required this.amount,
    required this.quantity,
  });

  factory SalesSummaryItem.fromJson(Map<String, dynamic> json) => SalesSummaryItem(
    item: json['item'],
    amount: json['_amount'],
    quantity: json['_quantity'],
  );
}

class SaleSummaryOrderType {
  final String item;
  final String totalSales;
  final String percent;

  const SaleSummaryOrderType({
    required this.item,
    required this.totalSales,
    required this.percent,
  });

  factory SaleSummaryOrderType.fromJson(Map<String, dynamic> json) => SaleSummaryOrderType(
    item: json['item'],
    totalSales: json['_total_sales'],
    percent: json['_percent'].toString().replaceAll(('%'), ''),
  );
}
