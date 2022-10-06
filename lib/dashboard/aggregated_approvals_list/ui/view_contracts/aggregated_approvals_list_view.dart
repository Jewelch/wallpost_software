abstract class AggregatedApprovalsListView {
  void showLoader();

  void updateList();

  void showErrorMessage(String message);

  void showNoMatchingResultsMessage(String message);

  void onDidProcessAllApprovals();
}
