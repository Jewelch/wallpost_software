import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';

abstract class ApprovalsListView {

  void onLoad();

  void onDidLoadApprovals(List<ApprovalAggregated> approvals);

  void showErrorMessage(String message);

  void onDidLoadCompanies(List<String> companies);

  void onDidLoadModules(List<String> modules);
}
