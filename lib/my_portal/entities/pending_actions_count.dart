import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class PendingActionsCount extends JSONInitializable {
  num _totalNotifications;
  num _taskApprovalsCount;
  num _leaveApprovalsCount;
  num _handoverApprovalsCount;

  PendingActionsCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var approvalMap = sift.readMapFromMap(jsonMap, 'approval');
      _totalNotifications = sift.readNumberFromMap(jsonMap, 'notifications');
      _taskApprovalsCount = sift.readNumberFromMap(approvalMap, 'task');
      _leaveApprovalsCount = sift.readNumberFromMap(approvalMap, 'leaves');
      _handoverApprovalsCount = sift.readNumberFromMap(approvalMap, 'handover');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast PendingActionsCount response. Error message - ${e.errorMessage}');
    }
  }

  num get taskApprovalsCount => _taskApprovalsCount;

  num get leaveApprovalsCount => _leaveApprovalsCount;

  num get handoverApprovalsCount => _handoverApprovalsCount;

  num get totalPendingActions => _taskApprovalsCount + _leaveApprovalsCount + _handoverApprovalsCount;
}
