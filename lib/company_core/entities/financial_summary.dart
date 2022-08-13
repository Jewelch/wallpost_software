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
      _profitLoss = sift.readStringFromMap(jsonMap, 'profitLoss');
      _fundAvailability = sift.readStringFromMap(jsonMap, 'cashAvailability');
      _receivableOverdue = sift.readStringFromMap(jsonMap, 'receivableOverdue');
      _payableOverdue = sift.readStringFromMap(jsonMap, 'payableOverdue');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinancialSummary response. Error message - ${e.errorMessage}');
    }
  }

  bool isInProfit() {
    return _isZero(_profitLoss) || _isGreaterThanZero(_profitLoss);
  }

  bool areFundsAvailable() {
    return _isGreaterThanZero(_fundAvailability);
  }

  bool areReceivablesOverdue() {
    return _isGreaterThanZero(_receivableOverdue);
  }

  bool arePayablesOverdue() {
    return _isGreaterThanZero(_payableOverdue);
  }

  bool _isZero(String value) {
    return value == "0";
  }

  bool _isLessThanZero(String value) {
    return value.contains("-");
  }

  bool _isGreaterThanZero(String value) {
    return !(_isLessThanZero(value) || _isZero(value));
  }

  String get profitLoss => "$_currency $_profitLoss";

  String get availableFunds => "$_currency $_fundAvailability";

  String get receivableOverdue => "$_currency $_receivableOverdue";

  String get payableOverdue => "$_currency $_payableOverdue";
}
