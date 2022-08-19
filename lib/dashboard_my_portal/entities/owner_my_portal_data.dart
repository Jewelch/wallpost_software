import 'package:sift/Sift.dart';
import 'package:wallpost/aggregated_approvals_list/entities/aggregated_approval.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';

import '../../_shared/exceptions/mapping_exception.dart';
import '../../_shared/json_serialization_base/json_initializable.dart';

class OwnerMyPortalData extends JSONInitializable {
  late List<AggregatedApproval> _aggregatedApprovals;
  late FinancialSummary _financialSummary;
  late num _companyPerformance;
  late int _absentees;

  OwnerMyPortalData.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var aggregatedApprovalsMapList = sift.readMapListFromMap(jsonMap, 'aggregated_approvals');
      var financialSummaryMap = sift.readMapFromMap(jsonMap, 'financial_summary');
      _aggregatedApprovals = _initAggregatedApprovals(aggregatedApprovalsMapList);
      _financialSummary = FinancialSummary.fromJson(financialSummaryMap);
      _companyPerformance = sift.readNumberFromMap(jsonMap, 'company_performance');
      _absentees = sift.readNumberFromMap(jsonMap, 'absentees').toInt();
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

  bool isCompanyPerformanceLow() {
    return _companyPerformance <= lowPerformanceCutoff();
  }

  bool isCompanyPerformanceMedium() {
    return _companyPerformance > lowPerformanceCutoff() && _companyPerformance <= mediumPerformanceCutoff();
  }

  bool isCompanyPerformanceHigh() {
    return _companyPerformance > mediumPerformanceCutoff();
  }

  int lowPerformanceCutoff() {
    return 65;
  }

  int mediumPerformanceCutoff() {
    return 79;
  }

  List<AggregatedApproval> get aggregatedApprovals => _aggregatedApprovals;

  FinancialSummary get financialSummary => _financialSummary;

  num get companyPerformance => _companyPerformance;

  int get absentees => _absentees;
}
