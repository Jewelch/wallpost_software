import 'package:sift/Sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/json_serialization_base/json_initializable.dart';

class AggregatedSalesData extends JSONInitializable {
  late String _totalSales;
  late String _netSales;
  late String _costOfSales;
  late String _grossOfProfit;

  AggregatedSalesData({
    required String totalSales,
    required String netSales,
    required String costOfSales,
    required String grossOfProfit,
  })  : _totalSales = totalSales,
        _netSales = netSales,
        _costOfSales = costOfSales,
        _grossOfProfit = grossOfProfit,
        super.fromJson({});

  factory AggregatedSalesData.empty() => AggregatedSalesData(totalSales: '0,00', netSales: '0,00', costOfSales: '0,00', grossOfProfit: '0');

  AggregatedSalesData.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    final sift = Sift();
    try {
      _totalSales = sift.readStringFromMap(jsonMap, 'total_sales');
      _netSales = sift.readStringFromMap(jsonMap, 'net_sales');
      _costOfSales = sift.readStringFromMap(jsonMap, 'cost_of_sales');
      _grossOfProfit = sift.readNumberFromMap(jsonMap, 'gross_of_profit').toString();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast SalesData response. Error message - ${e.errorMessage}');
    }
  }

  String get totalSales => _totalSales;

  String get netSales => _netSales;

  String get costOfSales => _costOfSales;

  String get grossOfProfit => '$_grossOfProfit%';
}
