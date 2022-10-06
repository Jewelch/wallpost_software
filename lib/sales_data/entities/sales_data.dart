import 'package:sift/Sift.dart';

import '../../_shared/exceptions/mapping_exception.dart';

class SalesData {
  late String _totalSales;
  late String _netSales;
  late String _costOfSales;
  late String _grossOfProfit;

  SalesData.fromJson(dynamic jsonMap) {
    final sift = Sift();

    try {
      _totalSales = sift.readStringFromMap(jsonMap, 'total_sales');
      _netSales = sift.readStringFromMap(jsonMap, 'net_sales');
      _costOfSales = sift.readStringFromMap(jsonMap, 'cost_of_sales');
      _grossOfProfit = sift.readNumberFromMap(jsonMap, 'gross_of_profit').toString();
    } on SiftException catch (e) {
      throw MappingException('Failed to cast SalesData response. Error message - ${e.errorMessage}');
    } on MappingException {
      rethrow;
    }
  }

  String get totalSales => _totalSales;
  String get netSales => _netSales;
  String get costOfSales => _costOfSales;
  String get grossOfProfit => '$_grossOfProfit%';
}
