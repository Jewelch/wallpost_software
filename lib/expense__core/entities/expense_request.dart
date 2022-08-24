import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_shared/money/money.dart';

import 'expense_request_approval_status.dart';

class ExpenseRequest extends JSONInitializable {
  late final String _id;
  late final String _companyId;
  late final String _requestNo;
  late final String _currency;
  late final Money? _rate;
  late final num? _quantity;
  late final Money _totalAmount;
  late final String _requestedBy;
  late final DateTime _requestDate;
  late final String? _mainCategory;
  late final String? _subCategory;
  late final String? _description;
  late final ExpenseRequestApprovalStatus _approvalStatus;
  late final String? _statusMessage;
  late final String? _attachmentUrl;

  ExpenseRequest.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var expenseDetailsMap = sift.readMapFromMapWithDefaultValue(jsonMap, "expense_detail", null);
      _id = "${sift.readNumberFromMap(jsonMap, 'expense_id')}";
      _companyId = "${sift.readNumberFromMap(jsonMap, 'company_id')}";
      _requestNo = sift.readStringFromMap(jsonMap, 'expense_request_no');
      _currency = sift.readStringFromMap(jsonMap, "currency");
      var rateString = sift.readStringFromMapWithDefaultValue(expenseDetailsMap, "rate", null);
      if (rateString != null) _rate = Money.fromString(rateString);
      _quantity = sift.readNumberFromMapWithDefaultValue(expenseDetailsMap, "quantity", null);
      var totalAmountString = sift.readStringFromMap(jsonMap, 'total_amount');
      _totalAmount = Money.fromString(totalAmountString);
      _requestedBy = sift.readStringFromMap(jsonMap, 'created_by_name');
      _requestDate = sift.readDateFromMap(jsonMap, "created_at", "yyyy-MM-dd HH:mm:ss");
      _mainCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'main_category');
      _subCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'sub_category');
      _description = sift.readStringFromMapWithDefaultValue(jsonMap, 'description');
      _approvalStatus = _readApprovalStatus(jsonMap);
      _statusMessage = _readStatusMessage(jsonMap);
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

  String get id => _id;

  String get companyId => _companyId;

  String get requestNo => _requestNo;

  String get currency => _currency;

  String get rate => _rate == null ? "" : "$_currency ${_rate.toString()}";

  num? get quantity => _quantity;

  String get totalAmount => "$_currency ${_totalAmount.toString()}";

  String get requestedBy => _requestedBy;

  DateTime get requestDate => _requestDate;

  String? get mainCategory => _mainCategory;

  String? get subCategory => _subCategory;

  String? get description => _description;

  ExpenseRequestApprovalStatus get approvalStatus => _approvalStatus;

  String? get statusMessage => _statusMessage;

  String? get attachmentUrl => _attachmentUrl;
}

/*
   "expense_id": 438,
        "expense_request_no": "TUT/ER/08/2022/00028",
        "total_amount": "234",
        "type": "hr",
        "created_at": "2022-08-23 13:02:32",
        "created_by": 3171,
        "created_by_name": "Eight  Emp",
        "status": "pending",
        "description": "asdasfdadsf",
        "main_category": "Employment Expense",
        "sub_category": "Change of sponsor",
        "status_message": "Approval Pending with",
        "status_user": "Eleven Teen - Software _Engineer",
        "expense_detail": [
            {
                "expense_date": "2022-08-23",
                "description": "asdasfdadsf",
                "quantity": 1,
                "rate": 234,
                "amount": 234,
                "doc_name": "",
                "doc_path": "",
                "doc_full_path": null
            }
        ]
    }
 */
/*
 {
            "expense_id": 438,
            "expense_request_no": "TUT/ER/08/2022/00028",
            "total_amount": "234",
            "type": "hr",
            "created_at": "2022-08-23 13:02:32",
            "created_by": 3171,
            "created_by_name": "Eight  Emp",
            "status": "pending",
            "description": "asdasfdadsf",
            "main_category": "Employment Expense",
            "sub_category": "Change of sponsor",
            "status_message": "Approval Pending with",
            "status_user": "Eleven Teen - Software _Engineer"
        },


{
"expense_id": 39,
"expense_request_no": "DCT/ER/07/2020/00034",
"total_amount": "120",
"type": "hr",
"created_at": "2020-07-28 12:04:43",
"created_by": 10,
"created_by_name": "Pramod  R",
"status": "approved",
"description": "",
"main_category": "Travel Expense",
"sub_category": "Business Trip allowance"
},
{
"expense_id": 32,
"expense_request_no": "DCT/ER/05/2020/00029",
"total_amount": "120",
"type": "hr",
"created_at": "2020-05-28 10:07:11",
"created_by": 10,
"created_by_name": "Pramod  R",
"status": "rejected",
"description": "",
"main_category": "Camp Expenses",
"sub_category": "Beds and Accessories",
"status_message": "Rejected By",
"status_user": "Pramod R"
}

expense_id": 174,
"expense_request_no": "AAT/ER/02/2021/00001",
"total_amount": "500",
"type": "hr",
"created_at": "2021-02-22 09:46:25",
"created_by": 545,
"created_by_name": "Pramod  R",
"status": "approved",
"description": "abcd",
"main_category": null,
"sub_category": null

{
"expense_id": 338,
"expense_request_no": "TESTCOMPANY/ER/10/2021/00006",
"total_amount": "500",
"type": "hr",
"created_at": "2021-10-29 10:21:18",
"created_by": 2,
"created_by_name": "Pramod  R",
"status": "approved",
"description": "test",
"main_category": "Employment Expense",
"sub_category": "Work Permit"
},
{
"expense_id": 335,
"expense_request_no": "TESTCOMPANY/ER/10/2021/00003",
"total_amount": "10",
"type": "hr",
"created_at": "2021-10-29 08:07:51",
"created_by": 2,
"created_by_name": "Pramod  R",
"status": "approved",
"description": "test for 2",
"main_category": "Camp Expenses",
"sub_category": "Cooking Gas"
}



 "data": {
        "expense_id": 439,
        "expense_request_no": "TUT/ER/08/2022/00029",
        "total_amount": "480",
        "type": "hr",
        "created_at": "2022-08-23 15:36:47",
        "created_by": 3171,
        "created_by_name": "Eight  Emp",
        "status": "pending",
        "description": "asdfasdfasf",
        "main_category": "Camp Expenses",
        "sub_category": "Beds and Accessories",
        "status_message": "Approval Pending with",
        "status_user": "Eleven Teen - Software _Engineer",
        "expense_detail": [
            {
                "expense_date": "2022-08-23",
                "description": "asdfasdfasf",
                "quantity": 4,
                "rate": 120,
                "amount": 480,
                "doc_name": "DOC332675_Flutter_Programming_Task.pdf",
                "doc_path": "expenseRequest/DOC332675_Flutter_Programming_Task.pdf",
                "doc_full_path": "https://s3.amazonaws.com/wallpostsoftware/120843/29/expenseRequest/DOC332675_Flutter_Programming_Task.pdf"
            }
        ]
    }
 */
