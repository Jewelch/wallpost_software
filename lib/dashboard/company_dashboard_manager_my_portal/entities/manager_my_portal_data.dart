import 'package:sift/sift.dart';

import '../../../../_shared/exceptions/mapping_exception.dart';
import '../../../../_shared/json_serialization_base/json_initializable.dart';
import '../../aggregated_approvals_list/entities/aggregated_approval.dart';

class ManagerMyPortalData extends JSONInitializable {
  late List<AggregatedApproval> _aggregatedApprovals;
  late num _departmentPerformance;

  ManagerMyPortalData.fromJson(Map<String, dynamic> jsonMap, String currency) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var aggregatedApprovalsMapList = sift.readMapListFromMap(jsonMap, 'aggregated_approvals');
      _aggregatedApprovals = _initAggregatedApprovals(aggregatedApprovalsMapList);
      _departmentPerformance = sift.readNumberFromMapWithDefaultValue(jsonMap, 'department_performance', 0)!;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast ManagerMyPortalData response. Error message - ${e.errorMessage}');
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

  num get departmentPerformance => _departmentPerformance;
}
