abstract class ExpenseRequestsView {
  void notifyMissingInputs();

  void showLoader();

  void hideLoader();

  void showErrorMessage(String message);

  void onSendRequestsSuccessfully();

}
