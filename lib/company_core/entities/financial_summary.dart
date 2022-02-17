import 'package:sift/sift.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_convertible.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class FinancialSummary extends JSONInitializable implements JSONConvertible {
  late String profitLoss;
  late String _fundAvailability;
  late String _receivableOverdue;
  late String _payableOverdue;

  FinancialSummary.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      profitLoss = "11";
      _fundAvailability = "11";
      _receivableOverdue = "11";
      _payableOverdue = "11";
    } on SiftException catch (e) {
      print(e.errorMessage);
      throw MappingException('Failed to cast Financial Summary response. Error message - ${e.errorMessage}');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      'profitLoss':  double.parse(profitLoss),
      'cashAvailability': double.parse(_fundAvailability),
      'receivableOverdue': double.parse(_receivableOverdue),
      'payableOverdue': double.parse(_payableOverdue),
    };
    return jsonMap;
  }

  String get overallRevenue => profitLoss;

  String get cashAvailability => _fundAvailability;

  String get receivableOverdue => _receivableOverdue;

  String get payableOverdue => _payableOverdue;
}
