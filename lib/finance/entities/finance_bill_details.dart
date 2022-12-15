import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class FinanceBillDetails extends JSONInitializable {
  late String _overDue;
  late String _currentDue;
  late String _billed;
  late String _paid;

  FinanceBillDetails.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _overDue = sift.readStringFromMap(jsonMap, "overdue");
      _currentDue = sift.readStringFromMap(jsonMap, 'current_due');
      _billed = sift.readStringFromMap(jsonMap, 'billed');
      _paid = sift.readStringFromMap(jsonMap, 'paid');

    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinancialSummary response. Error message - ${e.errorMessage}');
    }
  }

  String get paid => _paid;

  String get billed => _billed;

  String get currentDue => _currentDue;

  String get overDue => _overDue;
}
