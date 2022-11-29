import 'package:sift/Sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/json_serialization_base/json_initializable.dart';

class SalesBreakDownItem extends JSONInitializable {
  late double _totalSales;
  late String _totalSalesDisplayValue;
  late String _type;

  SalesBreakDownItem.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    final sift = Sift();
    try {
      _totalSales = sift.readNumberFromMap(jsonMap, 'total_sales').toDouble();
      _totalSalesDisplayValue = sift.readStringFromMap(jsonMap, 'total_sales_num_format');
      _type = sift.readStringFromMap(jsonMap, 'type');
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast SalesBreakDownData response. Error message - ${e.errorMessage}');
    }
  }

  double get totalSales => _totalSales;

  String get totalSalesDisplayValue => _totalSalesDisplayValue;

  String get type => _type;
}
