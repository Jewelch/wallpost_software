import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class Company extends JSONInitializable implements JSONConvertible {
  String _companyId;
  String _name;
  String _commercialName;
  String _currencyCode;
  String _colorCode;
  num _alertCount;
  num _approvalCount;
  num _notificationCount;
  String _actualSalesAmount;
  String _budgetedSalesAmount;
  num _achievedSalesPercent;
  bool _shouldShowRevenue;
  String _ytdPerformance;

  Company.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _companyId = '${sift.readNumberFromMap(jsonMap, 'companyId')}';
      _name = sift.readStringFromMap(jsonMap, 'name');
      _commercialName = sift.readStringFromMap(jsonMap, 'commercial_name');
      _currencyCode = sift.readStringFromMap(jsonMap, 'currency');
      _colorCode = sift.readStringFromMap(jsonMap, 'hexString');
      _alertCount = sift.readNumberFromMap(jsonMap, 'alerts');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approvals');
      _notificationCount = sift.readNumberFromMap(jsonMap, 'notifications');
      _actualSalesAmount = sift.readStringFromMap(jsonMap, 'actual_revenue_display');
      _budgetedSalesAmount = sift.readStringFromMap(jsonMap, 'budgeted_revenue_display');
      _achievedSalesPercent = sift.readNumberFromMap(jsonMap, 'overall_revenue');
      _shouldShowRevenue = sift.readNumberFromMap(jsonMap, 'show_revenue') == 0 ? false : true;
      _ytdPerformance = sift.readStringFromMap(jsonMap, 'ytd_performance');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Company response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'actual_revenue_display': _actualSalesAmount,
      'companyId': int.parse(_companyId),
      'name': _name,
      'commercial_name': _commercialName,
      'currency': _currencyCode,
      'hexString': _colorCode,
      'alerts': _alertCount,
      'approvals': _approvalCount,
      'notifications': _notificationCount,
      'budgeted_revenue_display': _budgetedSalesAmount,
      'overall_revenue': _achievedSalesPercent,
      'show_revenue': _shouldShowRevenue ? 1 : 0,
      'ytd_performance': _ytdPerformance,
    };
    return jsonMap;
  }

  String get actualSalesAmount => _actualSalesAmount;

  num get alertCount => _alertCount;

  num get approvalCount => _approvalCount;

  String get budgetedSalesAmount => _budgetedSalesAmount;

  String get commercialName => _commercialName;

  String get companyId => _companyId;

  String get currencyCode => _currencyCode;

  String get colorCode => _colorCode;

  String get name => _name;

  num get notificationCount => _notificationCount;

  num get achievedSalesPercent => _achievedSalesPercent;

  bool get shouldShowRevenue => _shouldShowRevenue;

  String get ytdPerformance => _ytdPerformance;
}
