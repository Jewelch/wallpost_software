import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class FinanceInvoiceDetails extends JSONInitializable {
  late String _overDue;
  late String _currentDue;
  late String _invoiced;
  late String _collected;

  FinanceInvoiceDetails.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _overDue = sift.readStringFromMap(jsonMap, "overdue");
      _currentDue = sift.readStringFromMap(jsonMap, 'currrent_due');
      _invoiced = sift.readStringFromMap(jsonMap, 'invoiced');
      _collected = sift.readStringFromMap(jsonMap, 'collected');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast FinanceInvoiceDetails response. Error message - ${e.errorMessage}');
    }
  }

  String get collected => _collected;

  String get invoiced => _invoiced;

  String get currentDue => _currentDue;

  String get overDue => _overDue;
}
