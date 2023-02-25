class AggregatedSalesSummary {
  final String grossSales;
  final String netSales;
  final String refund;
  final String tax;
  final String discounts;

  AggregatedSalesSummary({
    required this.grossSales,
    required this.netSales,
    required this.refund,
    required this.tax,
    required this.discounts,
  });

  factory AggregatedSalesSummary.fromJson(Map<String, dynamic> json) => AggregatedSalesSummary(
        grossSales: json['_gross_sales'],
        netSales: json['_net_sales'],
        refund: json['_refund'],
        tax: json['_tax'],
        discounts: json['_discounts'],
      );
}
