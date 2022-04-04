import 'package:wallpost/expense_requests/entities/expense_category.dart';

abstract class ExpenseRequestsView {
  void onStartFetchCategories() {}

  void onFetchCategoriesSuccessfully() {}

  void onFieldToFetchCategories(String userReadableMessage) {}

  void showSubCategories(List<ExpenseCategory> subCategories);

  void hideSubCategoriesView();

  void showProjects(List<ExpenseCategory> projects);

  void hideProjectsView();

  void resetErrors();

  void notifyMissingMainCategory();

  void notifyMissingSubCategory();

  void notifyMissingProject();

  void showLoader();

  void hideLoader();

  void showErrorMessage(String message);

  void onSendRequestsSuccessfully();
}
