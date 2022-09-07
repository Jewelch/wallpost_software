import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/money/money.dart';

import 'expense_request_approval_status.dart';

class ExpenseRequest extends JSONInitializable {
  late final String _id;
  late final String _companyId;
  late final String _requestNumber;
  late final String _currency;
  Money? _rate;
  num? _quantity;
  late final Money _totalAmount;
  late final String _requestedBy;
  late final DateTime _requestDate;
  String? _mainCategory;
  String? _subCategory;
  String? _project;
  String? _description;
  late final ExpenseRequestApprovalStatus _approvalStatus;
  String? _statusMessage;
  String? _rejectionReason;
  String? _attachmentUrl;

  ExpenseRequest.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var expenseDetailMapArray = sift.readMapListFromMapWithDefaultValue(jsonMap, "expense_detail", null);
      var expenseDetailsMap = sift.readMapFromListWithDefaultValue(expenseDetailMapArray, 0, null);
      _id = "${sift.readNumberFromMap(jsonMap, 'expense_id')}";
      _companyId = "${sift.readNumberFromMap(jsonMap, 'company_id')}";
      _requestNumber = sift.readStringFromMap(jsonMap, 'expense_request_no');
      _currency = sift.readStringFromMap(jsonMap, "currency");
      var rateAmount = sift.readNumberFromMapWithDefaultValue(expenseDetailsMap, "rate", null);
      if (rateAmount != null) _rate = Money(rateAmount);
      _quantity = sift.readNumberFromMapWithDefaultValue(expenseDetailsMap, "quantity", null);
      var totalAmountString = sift.readStringFromMap(jsonMap, 'total_amount');
      _totalAmount = Money.fromString(totalAmountString);
      _requestedBy = sift.readStringFromMap(jsonMap, 'created_by_name');
      _requestDate = sift.readDateFromMap(jsonMap, "created_at", "yyyy-MM-dd HH:mm:ss");
      _mainCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'main_category');
      _project = sift.readStringFromMapWithDefaultValue(jsonMap, 'project');
      _subCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'sub_category');
      _description = sift.readStringFromMapWithDefaultValue(jsonMap, 'description');
      _approvalStatus = _readApprovalStatus(jsonMap);
      _statusMessage = _readStatusMessage(jsonMap);
      _rejectionReason = sift.readStringFromMapWithDefaultValue(jsonMap, "rejection_message", null);
      _attachmentUrl = sift.readStringFromMapWithDefaultValue(expenseDetailsMap, "doc_full_path");
    } on SiftException catch (e) {
      throw MappingException('Failed to cast ExpenseRequest response. Error message - ${e.errorMessage}');
    }
  }

  ExpenseRequestApprovalStatus _readApprovalStatus(Map<String, dynamic> jsonMap) {
    var statusString = Sift().readStringFromMap(jsonMap, "status");
    var status = ExpenseRequestApprovalStatus.initFromString(statusString);

    if (status == null)
      throw MappingException('Failed to cast ExpenseRequest response. Invalid status - $statusString');

    return status;
  }

  String _readStatusMessage(Map<String, dynamic> jsonMap) {
    var statusMessage = Sift().readStringFromMapWithDefaultValue(jsonMap, "status_message", null);
    var statusUser = Sift().readStringFromMapWithDefaultValue(jsonMap, "status_user", null);
    if (statusMessage == null || statusUser == null) return "";

    return "$statusMessage $statusUser";
  }

  String getTitle() {
    var title = "";
    title += _mainCategory ?? "";
    if (title.isNotEmpty && (_project != null || _subCategory != null)) title += ": ";

    title += _project ?? "";
    if (title.isNotEmpty && _subCategory != null) title += " ";

    title += _subCategory ?? "";

    if (title.isEmpty && _description != null) title = _description!;

    return title;
  }

  String get id => _id;

  String get companyId => _companyId;

  String get requestNumber => _requestNumber;

  String get currency => _currency;

  String get rate => _rate == null ? "" : "$_currency ${_rate.toString()}";

  num? get quantity => _quantity;

  String get totalAmount => "$_currency ${_totalAmount.toString()}";

  String get requestedBy => _requestedBy;

  DateTime get requestDate => _requestDate;

  String? get mainCategory => _mainCategory;

  String? get project => _project;

  String? get subCategory => _subCategory;

  String? get description => _description;

  ExpenseRequestApprovalStatus get approvalStatus => _approvalStatus;

  String? get statusMessage => _statusMessage;

  String? get rejectionReason => _rejectionReason;

  String? get attachmentUrl => _attachmentUrl;
}
