import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_form_validator.dart';

abstract class ExpenseRequestsView {

  /*
  1. show load-categories loader - do we need this? is this functions caller again?
  2. on did load categories
  3.
   */
















  void onStartFetchCategories() {}

  void onFetchCategoriesSuccessfully() {}

  void onFieldToFetchCategories(String userReadableMessage) {}

  void showSubCategories(List<ExpenseCategory> subCategories);

  void hideSubCategoriesView();

  void showProjects(List<ExpenseCategory> projects);

  void hideProjectsView();

  void resetErrors();

  void notifyValidationErrors(ExpenseRequestFormValidator validator);

  void showLoader();

  void hideLoader();

  void showErrorMessage(String title, String message);

  void onSendRequestsSuccessfully();
}
