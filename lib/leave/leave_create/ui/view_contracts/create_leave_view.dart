abstract class CreateLeaveView {
  void showLeaveSpecsLoader();

  void onDidFailToLoadLeaveSpecs();

  void onDidLoadLeaveSpecs();

  void onDidSelectLeaveType();

  void onDidSelectStartDate();

  void onDidSelectEndDate();

  void onDidAddAttachment();

  void onDidRemoveAttachment();

  void updateValidationErrors();

  void showFormSubmissionLoader();

  void onDidFailToSubmitForm(String title, String message);

  void onDidSubmitFormSuccessfully(String title, String message);
}
