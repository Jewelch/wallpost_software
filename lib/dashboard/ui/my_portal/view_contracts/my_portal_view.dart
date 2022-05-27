

import '../../../../approvals/entities/approval.dart';

abstract class MyPortalView {


  void showErrorMessage(String message);

  void onDidLoadData();

  void onDidLoadApprovals(List<Approval> approvalsList);

  void onDidLoadActionsCount(num totalActions);



}
