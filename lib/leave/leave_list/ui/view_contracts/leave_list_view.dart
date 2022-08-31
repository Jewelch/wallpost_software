import '../../entities/leave_list_item.dart';

abstract class LeaveListView {
  void showLoader();

  void showErrorMessage();

  void showNoItemsMessage();

  void updateList();

  void showLeaveDetail(LeaveListItem leaveListItem);
}
