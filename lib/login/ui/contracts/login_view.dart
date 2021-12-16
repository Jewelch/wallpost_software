abstract class LoginView {
  void showLoader();

  void hideLoader();

  void notifyInvalidUsername();

  void notifyInvalidPassword();

  void notifyInvalidAccountNumber();

  void goToCompanyListScreen();

  void onLoginFailed(String title, String message);
}
