import 'package:sift/sift.dart';
import 'package:wallpost/approvals/entities/approval.dart';
import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class LeaveApproval  implements JSONInitializable{
  //need leave id and other things that are needed for approval - check with niyas
  late num _employeeId; //string
  late num  _leaveDays;
  late String _leaveFrom; // date
  late String _leaveTo; // date
  late num _status; //TODO: dynamic? - maybe string?
  late String _attachDoc; //_attachDocUrl
  late String _createdOn; // date
  late String _approveRequestBy; // what is this? check with niyas
  late String _decisionStatus; //nullable?
  late String? _rejectMessage; //TODO: dynamic? Maybe string?

  LeaveApproval.fromJson(Map<String, dynamic> jsonMap) {
    try {
      var sift = Sift();

      _employeeId = sift.readNumberFromMap(jsonMap, 'employee_id');
      _leaveDays = sift.readNumberFromMap(jsonMap, 'leave_days');
      _leaveFrom = sift.readStringFromMap(jsonMap, 'leave_from');
      _leaveTo = sift.readStringFromMap(jsonMap, 'leave_to');
      _status = sift.readNumberFromMap(jsonMap, 'status');
      _attachDoc = sift.readStringFromMap(jsonMap, 'attach_doc');
      _createdOn = sift.readStringFromMap(jsonMap, 'created_on');
      _approveRequestBy = sift.readStringFromMap(jsonMap, 'approve_request_by');
      _decisionStatus = sift.readStringFromMap(jsonMap, 'decision_status');
      _rejectMessage = sift.readStringFromMapWithDefaultValue(jsonMap, 'reject_message',null);


    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveApproval response. Error message - ${e.errorMessage}');
    }
  }


  num get employeeId => _employeeId;

  num get leaveDays => _leaveDays;

  String get leaveFrom => _leaveFrom;

  String get leaveTo => _leaveTo;

  num get status => _status;

  String get attachDoc => _attachDoc;

  String get createdOn => _createdOn;

  String get approveRequestBy => _approveRequestBy;

  String get decisionStatus => _decisionStatus;

  String? get rejectMessage => _rejectMessage;

}
