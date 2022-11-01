import 'package:sift/Sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/json_serialization_base/json_initializable.dart';

class SalesBreakDownItem extends JSONInitializable {
  late String _totalSales;
  late String _type;

  SalesBreakDownItem.fromJson(dynamic jsonMap) : super.fromJson(jsonMap) {
    final sift = Sift();
    try {
      print(jsonMap['total_sales']);
      _totalSales = sift.readNumberFromMap(jsonMap, 'total_sales').toStringAsFixed(2);
      _type = sift.readStringFromMap(jsonMap, 'type');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast SalesBreakDownData response. Error message - ${e.errorMessage}');
    }
  }

  String get totalSales => _totalSales;

  String get type => _type;
}
