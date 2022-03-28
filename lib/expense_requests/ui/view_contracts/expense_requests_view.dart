abstract class ExpenseRequestsView {
  void resetErrors();

  void notifyMissingMainCategory();

  void notifyMissingSubCategory();

  void showLoader();

  void hideLoader();

  void showErrorMessage(String message);

  void onSendRequestsSuccessfully();
}
