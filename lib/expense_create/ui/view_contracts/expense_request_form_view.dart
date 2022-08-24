abstract class ExpenseRequestFormView {
  void showCategoriesLoader();

  void onDidFailToLoadCategories();

  void onDidLoadCategories();

  void onDidSetDate();

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
