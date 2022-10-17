import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class RestaurantDashboardData extends JSONInitializable {
  late final String _todaysSale;
  late final String _ytdSale;

  RestaurantDashboardData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _todaysSale = sift.readStringFromMap(jsonMap, "at_a_glance_sales_amount");
      _ytdSale = sift.readStringFromMap(jsonMap, "filtered_sales_amount");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast RestaurantDashboardData response. Error message - ${e.errorMessage}');
    }
  }

  String get todaysSale => _todaysSale;

  String get ytdSale => _ytdSale;
}
