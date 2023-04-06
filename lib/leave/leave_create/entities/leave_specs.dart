import 'package:sift/sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/leave/leave_create/entities/ticket_details.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import 'leave_type.dart';

class LeaveSpecs extends JSONInitializable {
  late final List<LeaveType> _leaveTypes;
  late final bool _isEligibleForExitPermit;
  late final bool _isEligibleForTicket;
  late final TicketDetails? _ticketDetails;

  LeaveSpecs.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var leaveTypesMapList = sift.readMapListFromMap(jsonMap, 'leaveTypes');
      _leaveTypes = _readLeaveTypes(leaveTypesMapList);
      _isEligibleForExitPermit = sift.readBooleanFromMap(jsonMap, "exitPermit");
      _isEligibleForTicket = sift.readBooleanFromMap(jsonMap, "leaveTicket");
      if (_isEligibleForTicket) _ticketDetails = TicketDetails.fromJson(jsonMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveSpecs response. Error message - ${e.errorMessage}');
    }
  }

  List<LeaveType> _readLeaveTypes(List<Map<String, dynamic>> mapList) {
    List<LeaveType> leaveTypes = [];
    for (var leaveTypeMap in mapList) {
      leaveTypes.add(LeaveType.fromJson(leaveTypeMap));
    }
    return leaveTypes;
  }

  List<LeaveType> get leaveTypes => _leaveTypes;

  bool get isEligibleForExitPermit => _isEligibleForExitPermit;

  bool get isEligibleForTicket => _isEligibleForTicket;

  TicketDetails? get ticketDetails => _ticketDetails;
}
