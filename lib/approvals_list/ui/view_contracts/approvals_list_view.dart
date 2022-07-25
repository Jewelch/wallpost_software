import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';

abstract class ApprovalsListView {

  /*
  1.show loader?
  2. onDidLoadData(List approvals, List<String> companies, List<String> modules)
   */


  void onDidLoadApprovals(List<ApprovalAggregated> approvals);

  void showErrorMessage(String message);

  void onDidLoadData();

  void onLoad();

  void onDidLoadCompanies(List<String> companies);

  void onDidLoadModules(List<String> modules);
}
