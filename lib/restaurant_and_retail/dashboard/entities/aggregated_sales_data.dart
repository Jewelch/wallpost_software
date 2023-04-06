import 'package:sift/sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/json_serialization_base/json_initializable.dart';

class AggregatedSalesData extends JSONInitializable {
  late String _totalSales;
  late String _netSales;
  late String _costOfSales;
  late String _grossOfProfitPercentage;

  AggregatedSalesData.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    final sift = Sift();

    try {
      _totalSales = sift.readStringFromMap(jsonMap, 'total_sales');
      _netSales = sift.readStringFromMap(jsonMap, 'net_sales');
      _costOfSales = sift.readStringFromMap(jsonMap, 'cost_sales');
      _grossOfProfitPercentage = sift.readNumberFromMap(jsonMap, 'gross_profit_percentage').toString();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AggregatedSalesData response. Error message - ${e.errorMessage}');
    }
  }

  String get totalSales => _totalSales;

  String get netSales => _netSales;

  String get costOfSales => _costOfSales;

  String get grossOfProfit => '$_grossOfProfitPercentage';
}
