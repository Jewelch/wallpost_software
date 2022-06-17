import 'package:sift/sift.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';
import 'approval.dart';

class LeaveApproval extends Approval implements JSONInitializable {
  late num _employeeId; //string
  late num _leaveDays;
  late String _leaveFrom; // date
  late String _leaveTo; // date
  late num _status;
  late String _attachDoc;
  late String _createdOn; // date
  late String _approveRequestBy;
  late String _decisionStatus;
  late String? _rejectMessage;

  LeaveApproval.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();

      var detailsMap = sift.readMapFromMap(jsonMap, 'details');
      _employeeId = sift.readNumberFromMap(detailsMap, 'employee_id');
      _leaveDays = sift.readNumberFromMap(detailsMap, 'leave_days');
      _leaveFrom = sift.readStringFromMap(detailsMap, 'leave_from');
      _leaveTo = sift.readStringFromMap(detailsMap, 'leave_to');
      _status = sift.readNumberFromMap(detailsMap, 'status');
      _attachDoc = sift.readStringFromMap(detailsMap, 'attach_doc');
      _createdOn = sift.readStringFromMap(detailsMap, 'created_on');
      _approveRequestBy = sift.readStringFromMap(detailsMap, 'approve_request_by');
      _decisionStatus = sift.readStringFromMap(detailsMap, 'decision_status');
      _rejectMessage = sift.readStringFromMapWithDefaultValue(detailsMap, 'reject_message', null);
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
