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
  late String _avatar;
  late String _profitLoss;
  late String _receivableOverdue;
  late String _fundAvailability;
  late String _payableOverdue;

  CompanyListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = '${sift.readNumberFromMap(jsonMap, 'company_id')}';
      _name = sift.readStringFromMap(jsonMap, 'company_name');
      _approvalCount = sift.readNumberFromMap(jsonMap, 'approval_count');
      _notificationCount = sift.readNumberFromMap(jsonMap, 'notifications');
      var financialSummaryMap = sift.readMapFromMap(jsonMap, 'financial_summary');
      _currencyCode = sift.readStringFromMap(financialSummaryMap, 'currency');
      _actualSalesAmount = sift.readStringFromMap(financialSummaryMap, 'actual_revenue_display');
      _achievedSalesPercent = sift.readNumberFromMap(financialSummaryMap, 'overall_revenue');
      _avatar = 'https://placeimg.com/640/480/any';
      _profitLoss = "180,000";
      _receivableOverdue = "80,000";
      _fundAvailability = "200,000";
      _payableOverdue = "50,000";
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
      'avatar': _avatar,
      'profit_loss': _profitLoss,
      'receivable_overdue': _receivableOverdue,
      'fund_availability': _fundAvailability,
      'payable_overdue': _payableOverdue
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

  String get avatar => _avatar;

  String get profitLoss => _profitLoss;

  String get receivableOverdue => _receivableOverdue;

  String get fundAvailability => _fundAvailability;

  String get payableOverdue => _payableOverdue;
}
