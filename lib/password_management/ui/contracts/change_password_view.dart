abstract class ChangePasswordView {
  void showLoader();

  void hideLoader();

  void notifyInvalidCurrentPassword(String message);

  void notifyInvalidNewPassword(String message);

  void notifyInvalidConfirmPassword(String message);

  void clearErrors();

  void goToSuccessScreen();

  void onChangePasswordFailed(String title, String message);
}
