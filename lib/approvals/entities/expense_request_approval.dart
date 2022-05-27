

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

       _expenseRequestNumber =
           sift.readStringFromMap(jsonMap, 'expense_request_no');
       _totalAmount = sift.readStringFromMap(jsonMap, 'total_amount');
       _createdAt = sift.readStringFromMap(jsonMap, 'created_at');
       _createdById = sift.readNumberFromMap(jsonMap, 'created_by_id');
       _createdByName = sift.readStringFromMap(jsonMap, 'created_by_name');
       _mainCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'main_category',null);
       _subCategory = sift.readStringFromMapWithDefaultValue(jsonMap, 'sub_category',null);
       _description = sift.readStringFromMap(jsonMap, 'description');
       _status = sift.readStringFromMap(jsonMap, 'status');
       _statusMessage = sift.readStringFromMap(jsonMap, 'status_message');
       _statusUser = sift.readStringFromMap(jsonMap, 'status_user');
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
