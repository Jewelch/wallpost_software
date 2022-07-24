abstract class MainView {
  void setStatusBarColor(bool isLoggedIn);

  void goToLoginScreen();

  void goToCompaniesListScreen();

  void goToDashboardScreen();

  void onError(String message);
}
