abstract class CreateExpenseRequestView {
  void showCategoriesLoader();

  void onDidFailToLoadCategories();

  void onDidLoadCategories();

  void onDidSelectDate();

  void onDidSelectMainCategory();

  void onDidSelectProject();

  void onDidSelectSubCategory();

  void onDidAddAttachment();

  void onDidRemoveAttachment();

  void updateTotalAmount();

  void updateValidationErrors();

  void showFormSubmissionLoader();

  void onDidFailToSubmitForm(String title, String message);

  void onDidSubmitFormSuccessfully(String title, String message);
}
