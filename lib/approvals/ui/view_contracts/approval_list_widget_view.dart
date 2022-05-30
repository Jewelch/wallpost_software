import '../../entities/approval.dart';

abstract class ApprovalListWidgetView {

  void onDidLoadApprovals(List<Approval> approvals);

  void showErrorMessage(String message);

  void onDidLoadData();

  void onLoad();

  void onDidLoadActionsCount(num totalActions);

}