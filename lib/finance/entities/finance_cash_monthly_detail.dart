import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class FinanceCashMonthlyDetails extends JSONInitializable {
  late List<String> _months;
  late List<String> _cashIn;
  late List<String> _cashOut;

  FinanceCashMonthlyDetails.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _months = sift.readStringListFromMap(jsonMap, "months");
      _cashIn = sift.readStringListFromMap(jsonMap, "cache_in");
      _cashOut = sift.readStringListFromMap(jsonMap, "cache_out");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinancialSummary response. Error message - ${e.errorMessage}');
    }
  }

  List<String> get cashOut => _cashOut;

  List<String> get cashIn => _cashIn;

  List<String> get months => _months;
}
