import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class CompanyListItem extends JSONInitializable implements JSONConvertible {
  late String _id;
  late String _name;
  late String _currencyCode;
  late num _approvalCount;
  late num _notificationCount;
  late String _actualSalesAmount;
  late num _achievedSalesPercent;

  CompanyListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _name = sift.readStringFromMap(jsonMap, 'company_name');
      _currencyCode = sift.readStringFromMap(jsonMap, 'currency');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approval_count');
      _notificationCount = sift.readNumberFromMap(jsonMap, 'notifications');
      _actualSalesAmount = sift.readStringFromMap(jsonMap, 'actual_revenue_display');
      _achievedSalesPercent = sift.readNumberFromMap(jsonMap, 'overall_revenue');
    } on SiftException catch (e) {
      print(e.errorMessage);
      throw MappingException('Failed to cast CompanyListItem response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'actual_revenue_display': _actualSalesAmount,
      'company_id': int.parse(_id),
      'company_name': _name,
      'currency': _currencyCode,
      'approval_count': _approvalCount,
      'notifications': _notificationCount,
      'overall_revenue': _achievedSalesPercent,
    };
    return jsonMap;
  }

  String get id => _id;

  String get name => _name;

  String get currencyCode => _currencyCode;

  num get approvalCount => _approvalCount;

  num get notificationCount => _notificationCount;

  String get actualSalesAmount => _actualSalesAmount;

  num get achievedSalesPercent => _achievedSalesPercent;
}
