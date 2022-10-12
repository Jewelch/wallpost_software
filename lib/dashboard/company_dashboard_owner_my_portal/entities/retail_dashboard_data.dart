import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../../_shared/exceptions/mapping_exception.dart';

class RetailDashboardData extends JSONInitializable {
  late final String _todaysSale;
  late final String _ytdSale;

  RetailDashboardData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _todaysSale = sift.readStringFromMap(jsonMap, "todays_sale");
      _ytdSale = sift.readStringFromMap(jsonMap, "ytd_sale");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast RetailDashboardData response. Error message - ${e.errorMessage}');
    }
  }

  String get todaysSale => _todaysSale;

  String get ytdSale => _ytdSale;
}
