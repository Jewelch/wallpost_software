import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class FinanceInvoiceReport extends JSONInitializable {
  late String _overDue;
  late String _currentDate;
  late String _invoiced;
  late String _collected;

  FinanceInvoiceReport.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _overDue = sift.readStringFromMap(jsonMap, "overdue");
      _currentDate = sift.readStringFromMap(jsonMap, 'currrent_due');
      _invoiced = sift.readStringFromMap(jsonMap, 'invoiced');
      _collected = sift.readStringFromMap(jsonMap, 'collected');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinancialSummary response. Error message - ${e.errorMessage}');
    }
  }

  String get collected => _collected;

  String get invoiced => _invoiced;

  String get currentDate => _currentDate;

  String get overDue => _overDue;
}
