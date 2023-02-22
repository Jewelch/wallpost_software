abstract class AttendanceAdjustmentApprovalListView {
  void showLoader();

  void showErrorMessage();

  void showNoItemsMessage();

  void updateList();

  void onDidProcessAllApprovals();

  void onDidInitiateMultipleSelection();

  void onDidEndMultipleSelection();
}
