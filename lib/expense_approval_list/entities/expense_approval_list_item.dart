import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

import '../../_shared/exceptions/mapping_exception.dart';

class ExpenseApprovalListItem extends JSONInitializable {
  late String _id;
  late String _companyId;
  late String? _mainCategory;
  late String? _project;
  late String? _subCategory;
  late String _requestedBy;
  late String _requestNumber;
  late DateTime _requestDate;
  late String _totalAmount;

  ExpenseApprovalListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var requestedByMap = sift.readMapFromMap(jsonMap, "requested_by");
      _id = "${sift.readNumberFromMap(jsonMap, "expense_id")}";
      _companyId = "${sift.readNumberFromMap(jsonMap, "company_id")}";
      _mainCategory = sift.readStringFromMapWithDefaultValue(jsonMap, "main_category", null);
      _project = sift.readStringFromMapWithDefaultValue(jsonMap, "project", null);
      _subCategory = sift.readStringFromMapWithDefaultValue(jsonMap, "sub_category", null);
      _requestedBy = sift.readStringFromMap(requestedByMap, "full_name");
      _requestNumber = sift.readStringFromMap(jsonMap, "expense_request_no");
      _requestDate = sift.readDateFromMap(jsonMap, "created_at", "yyyy-MM-dd HH:mm:ss");
      var currency = sift.readStringFromMap(jsonMap, "currency");
      var amountString = sift.readStringFromMap(jsonMap, "total_amount");
      _totalAmount = "$currency $amountString";
    } on SiftException catch (e) {
      throw MappingException('Failed to cast ExpenseApproval response. Error message - ${e.errorMessage}');
    }
  }

  String getTitle() {
    var title = "";
    title += mainCategory ?? "";
    if (title.isNotEmpty && (project != null || subCategory != null)) title += ": ";

    title += project ?? "";
    if (title.isNotEmpty && subCategory != null) title += " ";

    title += subCategory ?? "";

    return title;
  }

  String get id => _id;

  String get companyId => _companyId;

  String? get mainCategory => _mainCategory;

  String? get project => _project;

  String? get subCategory => _subCategory;

  String get requestedBy => _requestedBy;

  String get requestNumber => _requestNumber;

  DateTime get requestDate => _requestDate;

  String get totalAmount => _totalAmount;
}
