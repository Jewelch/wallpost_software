import 'package:sift/sift.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class FinancialSummary extends JSONInitializable {
  late String _currency;
  late String _profitLoss;
  late String _fundAvailability;
  late String _receivableOverdue;
  late String _payableOverdue;

  FinancialSummary.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _currency = sift.readStringFromMap(jsonMap, "currency");
      _profitLoss = _currency + " " + sift.readStringFromMap(jsonMap, 'profitLoss');
      _fundAvailability = _currency + " " + sift.readStringFromMap(jsonMap, 'cashAvailability');
      _receivableOverdue = _currency + " " + sift.readStringFromMap(jsonMap, 'receivableOverdue');
      _payableOverdue = _currency + " " + sift.readStringFromMap(jsonMap, 'payableOverdue');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinancialSummary response. Error message - ${e.errorMessage}');
    }
  }

  String get currency => _currency;

  String get profitLoss => _profitLoss;

  String get availableFunds => _fundAvailability;

  String get receivableOverdue => _receivableOverdue;

  String get payableOverdue => _payableOverdue;
}
