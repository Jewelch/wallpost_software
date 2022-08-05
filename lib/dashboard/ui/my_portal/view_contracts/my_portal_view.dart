

import '../../../../approvals_list/entities/approval_aggregated.dart';

abstract class MyPortalView {

  void onLoad();

  void showErrorMessage(String message);

  void onDidLoadApprovals(List<ApprovalAggregated> approvalsList);

  void onDidLoadActionsCount(num totalActions);

}
