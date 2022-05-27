

import 'package:sift/Sift.dart';
import 'package:wallpost/approvals/entities/approval.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class ExpenseRequestApproval  implements JSONInitializable{
  late num _id;
  late num _companyId;
   late String  _expenseRequestNumber ;
   late String _totalAmount ;
   late String _createdAt ;
   late num _createdById ;
   late String _createdByName ;
   late String? _mainCategory ;
   late String? _subCategory ;
   late String _description ;
   late String _status ;
   late String _statusMessage ;
   late String _statusUser ;

   ExpenseRequestApproval.fromJson(Map<String, dynamic> jsonMap){
     try {
       var sift = Sift();
       var detailsMap = sift.readMapFromMap(jsonMap, "details");

       _expenseRequestNumber =
           sift.readStringFromMap(detailsMap, 'expense_request_no');
       _totalAmount = sift.readStringFromMap(detailsMap, 'total_amount');
       _createdAt = sift.readStringFromMap(detailsMap, 'created_at');
       _createdById = sift.readNumberFromMap(detailsMap, 'created_by_id');
       _createdByName = sift.readStringFromMap(detailsMap, 'created_by_name');
       _mainCategory = sift.readStringFromMapWithDefaultValue(detailsMap, 'main_category',null);
       _subCategory = sift.readStringFromMapWithDefaultValue(detailsMap, 'sub_category',null);
       _description = sift.readStringFromMap(detailsMap, 'description');
       _status = sift.readStringFromMap(detailsMap, 'status');
       _statusMessage = sift.readStringFromMap(detailsMap, 'status_message');
       _statusUser = sift.readStringFromMap(detailsMap, 'status_user');
     } on SiftException catch (e) {
       throw MappingException('Failed to cast ExpenseRequestApproval response. Error message - ${e.errorMessage}');
     }

   }


  String get expenseRequestNumber => _expenseRequestNumber;

  String get totalAmount => _totalAmount;

  String get createdAt => _createdAt;

  num get createdById => _createdById;

  String get createdByName => _createdByName;

  String? get mainCategory => _mainCategory;

  String? get subCategory => _subCategory;

  String get description => _description;

  String get status => _status;

  String get statusMessage => _statusMessage;

  String get statusUser => _statusUser;

}
