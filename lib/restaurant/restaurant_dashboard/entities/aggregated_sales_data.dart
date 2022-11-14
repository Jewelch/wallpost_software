import '../../../_shared/exceptions/mapping_exception.dart';

// class AggregatedSalesData extends JSONInitializable {
//   String? _totalSales;
//   String? _netSales;
//   String? _costOfSales;
//   String? _grossOfProfitPercentage;

//   AggregatedSalesData.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
//     final sift = Sift();

//     try {
//       _totalSales = sift.readStringFromMap(jsonMap, 'total_sales');
//       _netSales = sift.readStringFromMap(jsonMap, 'net_sales');
//       _costOfSales = sift.readStringFromMap(jsonMap, 'cost_sales');
//       _grossOfProfitPercentage = sift.readNumberFromMap(jsonMap, 'gross_profit_percentage').toString();
//     } on SiftException catch (e) {
//       throw MappingException('Failed to cast AggregatedSalesData response. Error message - ${e.errorMessage}');
//     }
//   }

//   String? get totalSales => _totalSales;

//   String? get netSales => _netSales;

//   String? get costOfSales => _costOfSales;

//   String? get grossOfProfit => '$_grossOfProfitPercentage';
// }

class AggregatedSalesData {
  final String? totalSales;
  final String? netSales;
  final String? costOfSales;
  final String? grossOfProfit;

  AggregatedSalesData({
    this.totalSales,
    this.netSales,
    this.costOfSales,
    this.grossOfProfit,
  });

  factory AggregatedSalesData.fromJson(dynamic jsonMap) {
    try {
      return AggregatedSalesData(
        totalSales: jsonMap['total_sales'],
        netSales: jsonMap['net_sales'],
        costOfSales: jsonMap['cost_sales'],
        grossOfProfit: jsonMap['gross_profit_percentage']?.toString(),
      );
    } on Error catch (e) {
      throw MappingException('Failed to cast AggregatedSalesData response. Error message - $e');
    }
  }
}
