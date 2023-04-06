import 'package:sift/sift.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';
import '../../../../_shared/json_serialization_base/json_initializable.dart';
import '../../aggregated_approvals_list/entities/aggregated_approval.dart';

class EmployeeMyPortalData extends JSONInitializable {
  late List<AggregatedApproval> _aggregatedApprovals;
  late num _ytdPerformance;
  late num _currentMonthPerformance;
  late num _currentMonthAttendancePerformance;

  EmployeeMyPortalData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var aggregatedApprovalsMapList = sift.readMapListFromMap(jsonMap, 'aggregated_approvals');
      _aggregatedApprovals = _initAggregatedApprovals(aggregatedApprovalsMapList);
      _ytdPerformance = sift.readNumberFromMap(jsonMap, 'ytd_performance');
      _currentMonthPerformance = sift.readNumberFromMap(jsonMap, 'current_month_performance');
      _currentMonthAttendancePerformance = sift.readNumberFromMap(jsonMap, 'current_month_attendance_percentage');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Company response. Error message - ${e.errorMessage}');
    } on MappingException {
      rethrow;
    }
  }

  List<AggregatedApproval> _initAggregatedApprovals(List<Map<String, dynamic>> aggregatedApprovalsMapList) {
    List<AggregatedApproval> approvalsList = [];
    for (var aggregatedApprovalMap in aggregatedApprovalsMapList) {
      var aggregatedApproval = AggregatedApproval.fromJson(aggregatedApprovalMap);
      approvalsList.add(aggregatedApproval);
    }
    return approvalsList;
  }

  List<AggregatedApproval> get aggregatedApprovals => _aggregatedApprovals;

  num get ytdPerformance => _ytdPerformance;

  num get currentMonthPerformance => _currentMonthPerformance;

  num get currentMonthAttendancePerformance => _currentMonthAttendancePerformance;
}
