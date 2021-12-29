abstract class ForgotPasswordView {
  void showLoader();

  void hideLoader();

  void notifyInvalidAccountNumber(String message);

  void notifyInvalidEmailFormat(String message);

  void clearErrors();

  void goToSuccessScreen();

  void onResetPasswordFailed(String title, String message);
}
