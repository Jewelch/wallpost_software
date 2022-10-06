import '../../entities/leave_approval_list_item.dart';

abstract class LeaveApprovalListView {
  void showLoader();

  void showErrorMessage();

  void showNoItemsMessage();

  void updateList();

  void showLeaveDetail(LeaveApprovalListItem approval);

  void onDidProcessAllApprovals();
}
