abstract class LoginView {
  void showLoader();

  void hideLoader();

  void notifyInvalidAccountNumber(String message);

  void notifyInvalidUsername(String message);

  void notifyInvalidPassword(String message);

  void goToCompanyListScreen();

  void onLoginFailed(String title, String message);
}
