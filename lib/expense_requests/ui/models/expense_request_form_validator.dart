import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';

class ExpenseRequestFormValidator {
  ExpenseRequestModel model;

  ExpenseRequestFormValidator(this.model);

  String mainCategoryMissingError = "";
  String subCategoryMissingError = "";
  String projectMissingError = "";
  String amountMissingError = "";
  String quantityMissingError = "";
  String fileMissingError = "";

  bool validate() {
    _validateMainCategory();
    _validateSubCategory();
    _validateProject();
    _validateAmount();
    _validateQuantity();
    _validateFileExisted();
    return _isValid();
  }

  void _validateMainCategory() {
    mainCategoryMissingError = "";
    if (model.selectedMainCategory == null) {
      mainCategoryMissingError = "Please select a type";
    }
  }

  void _validateSubCategory() {
    subCategoryMissingError = "";
    if (model.selectedMainCategory != null &&
        model.selectedMainCategory!.subCategories.isNotEmpty &&
        model.selectedSubCategory == null) {
      subCategoryMissingError = "Please select a sub type";
    }
  }

  void _validateProject() {
    projectMissingError = "";
    if (model.selectedMainCategory != null &&
        model.selectedMainCategory!.projects.isNotEmpty &&
        model.selectedProject == null) {
      projectMissingError = "Please select a project";
    }
  }

  void _validateAmount() {
    amountMissingError = "";
    if (!Money.fromString(model.amount).greaterThan(Money.zero())) {
      amountMissingError = "Please enter an amount";
    }
  }

  void _validateQuantity() {
    quantityMissingError = "";
    if (model.quantity <= 0) {
      quantityMissingError = "Please enter a quantity";
    }
  }

  void _validateFileExisted() {
    fileMissingError = "";
    if (model.file == null) {
      fileMissingError = "Please attach a document";
    }
  }

  bool _isValid() {
    return mainCategoryMissingError.isEmpty &&
        subCategoryMissingError.isEmpty &&
        projectMissingError.isEmpty &&
        amountMissingError.isEmpty &&
        quantityMissingError.isEmpty &&
        fileMissingError.isEmpty;
  }
}
