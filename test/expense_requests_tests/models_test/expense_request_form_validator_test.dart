import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_form_validator.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';

main() {
  var model = ExpenseRequestModel();
  ExpenseRequestFormValidator validator = ExpenseRequestFormValidator(model);
  // MARK: helpers function
  ExpenseCategory _getCategoryWithSubCategories() =>
      ExpenseCategory('', '', [ExpenseCategory('', '', [], [])], []);

  ExpenseCategory _getCategoryWithProjects() => ExpenseCategory(
        '',
        '',
        [],
        [ExpenseCategory('', '', [], [])],
      );

  ExpenseCategory _getCategoryWithSubAndProjects() => ExpenseCategory(
        '',
        '',
        [ExpenseCategory('', '', [], [])],
        [ExpenseCategory('', '', [], [])],
      );

  test('all errors are empty at initialization', () {
    ExpenseRequestFormValidator validator = ExpenseRequestFormValidator(model);

    expect(validator.mainCategoryMissingError, "");
    expect(validator.subCategoryMissingError, "");
    expect(validator.projectMissingError, "");
    expect(validator.amountMissingError, "");
    expect(validator.quantityMissingError, "");
    expect(validator.fileMissingError, "");
  });

  test('validate main category with missing value', () {
    model.selectedMainCategory = null;

    validator.validate();

    expect(validator.mainCategoryMissingError, "Please select a type");
  });

  test('validate main category with valid value', () {
    model.selectedMainCategory = ExpenseCategory('', '', [], []);

    validator.validate();

    expect(validator.mainCategoryMissingError, "");
  });

  test('validate sub category with missing value', () {
    model.selectedMainCategory = _getCategoryWithSubCategories();

    validator.validate();

    expect(validator.subCategoryMissingError, "Please select a sub type");
  });

  test('validate sub category with valid value', () {
    model.selectedMainCategory = _getCategoryWithSubCategories();
    model.selectedSubCategory = ExpenseCategory('', '', [], []);

    validator.validate();

    expect(validator.subCategoryMissingError, "");
  });

  test('validate project with missing value', () {
    model.selectedMainCategory = _getCategoryWithProjects();

    validator.validate();

    expect(validator.projectMissingError, "Please select a project");
  });

  test('validate project with valid value', () {
    model.selectedMainCategory = _getCategoryWithProjects();
    model.selectedProject = ExpenseCategory('', '', [], []);

    validator.validate();

    expect(validator.projectMissingError, "");
  });

  test('validate amount with un valid value', () {
    model.setAmount("0");

    validator.validate();

    expect(validator.amountMissingError, "Please enter an amount");
  });

  test('validate amount with valid value', () {
    model.setAmount("1");

    validator.validate();

    expect(validator.amountMissingError, "");
  });

  test('validate quantity with un valid value', () {
    model.setQuantity("0");

    validator.validate();

    expect(validator.quantityMissingError, "Please enter a quantity");
  });

  test('validate quantity with valid value', () {
    model.setQuantity("1");

    validator.validate();

    expect(validator.quantityMissingError, "");
  });

  test('validate file with un valid value', () {
    model.file = null;

    validator.validate();

    expect(validator.fileMissingError, "Please attach a document");
  });

  test('validate quantity with valid value', () {
    model.file = File("path");

    validator.validate();

    expect(validator.fileMissingError, "");
  });

  test('validate function returns true only when all validation succeed', () {
    var model = ExpenseRequestModel();
    ExpenseRequestFormValidator validator = ExpenseRequestFormValidator(model);
    bool isValid = false;

    // all fields unValid
    isValid = validator.validate();
    expect(isValid, false);

    // just main category is valid
    model.selectedMainCategory = _getCategoryWithSubAndProjects();
    isValid = validator.validate();
    expect(isValid, false);

    // just main category and sub category are valid
    model.selectedSubCategory = _getCategoryWithSubAndProjects();
    isValid = validator.validate();
    expect(isValid, false);

    // just main category, sub category and project are valid
    model.selectedProject = _getCategoryWithSubAndProjects();
    isValid = validator.validate();
    expect(isValid, false);

    // just main category, sub category, project and amount are valid
    model.setAmount("1");
    isValid = validator.validate();
    expect(isValid, false);

    // just main category, sub category, project, amount and quantity are valid
    model.setQuantity("1");
    isValid = validator.validate();
    expect(isValid, false);

    // all Valid
    model.file = File("path");
    isValid = validator.validate();
    expect(isValid, true);
  });
}
