abstract class AggregatedApprovalsListView {
  void showLoader();

  void onDidLoadApprovals();

  void showErrorMessage(String message);

  void showNoMatchingResultsMessage(String message);
}
