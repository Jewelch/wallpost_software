// @dart=2.9

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class CompanyListItem extends JSONInitializable implements JSONConvertible {
  String _id;
  String _name;
  String _currencyCode;
  num _approvalCount;
  num _alertCount;
  num _notificationCount;
  String _actualSalesAmount;
  num _achievedSalesPercent;
  bool _shouldShowRevenue;

  CompanyListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = '${sift.readNumberFromMap(jsonMap, 'companyId')}';
      _name = sift.readStringFromMap(jsonMap, 'name');
      _currencyCode = sift.readStringFromMap(jsonMap, 'currency');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approvals');
      _alertCount = sift.readNumberFromMap(jsonMap, 'alerts');
      _notificationCount = sift.readNumberFromMap(jsonMap, 'notifications');
      _actualSalesAmount = sift.readStringFromMap(jsonMap, 'actual_revenue_display');
      _achievedSalesPercent = sift.readNumberFromMap(jsonMap, 'overall_revenue');
      _shouldShowRevenue = sift.readNumberFromMap(jsonMap, 'show_revenue') == 0 ? false : true;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast CompanyListItem response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'actual_revenue_display': _actualSalesAmount,
      'companyId': int.parse(_id),
      'name': _name,
      'currency': _currencyCode,
      'approvals': _approvalCount,
      'alerts': _alertCount,
      'notifications': _notificationCount,
      'overall_revenue': _achievedSalesPercent,
      'show_revenue': _shouldShowRevenue ? 1 : 0,
    };
    return jsonMap;
  }

  String get id => _id;

  String get name => _name;

  String get currencyCode => _currencyCode;

  num get approvalCount => _approvalCount;

  num get alertCount => _alertCount;

  num get notificationCount => _notificationCount;

  String get actualSalesAmount => _actualSalesAmount;

  num get achievedSalesPercent => _achievedSalesPercent;

  bool get shouldShowRevenue => _shouldShowRevenue;
}
