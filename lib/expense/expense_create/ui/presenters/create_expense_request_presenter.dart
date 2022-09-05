import 'dart:core';
import 'dart:io';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/_shared/money/money_initialization_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/expense/expense_create/ui/models/expense_request_model.dart';

import '../../entities/expense_category.dart';
import '../../entities/expense_request_form.dart';
import '../../services/expense_categories_provider.dart';
import '../../services/expense_request_creator.dart';
import '../view_contracts/create_expense_request_view.dart';

class CreateExpenseRequestPresenter {
  CreateExpenseRequestView _view;
  ExpenseCategoriesProvider _categoriesProvider;
  ExpenseRequestCreator _requestCreator;
  SelectedCompanyProvider _companyProvider;
  List<ExpenseCategory> _categories = [];
  var _form = ExpenseRequestForm();
  var _model = ExpenseRequestModel();

  CreateExpenseRequestPresenter(this._view)
      : _categoriesProvider = ExpenseCategoriesProvider(),
        _requestCreator = ExpenseRequestCreator(),
        _companyProvider = SelectedCompanyProvider();

  CreateExpenseRequestPresenter.initWith(
    this._view,
    this._categoriesProvider,
    this._requestCreator,
    this._companyProvider,
  );

  //MARK: Functions to load categories

  Future<void> loadCategories() async {
    if (_categoriesProvider.isLoading) return;

    _model.loadCategoriesError = null;
    _view.showCategoriesLoader();

    try {
      var categories = await _categoriesProvider.get();
      _processResponse(categories);
    } on WPException catch (e) {
      _model.loadCategoriesError = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadCategories();
    }
  }

  void _processResponse(List<ExpenseCategory> categories) {
    _categories = categories;

    if (_categories.isNotEmpty) {
      _view.onDidLoadCategories();
      _form.date = DateTime.now();
      selectMainCategoryAtIndex(0);
    } else {
      _model.loadCategoriesError = "There are no categories to show.\n\nTap here to reload.";
      _view.onDidFailToLoadCategories();
    }
  }

  //MARK: Function to select form data

  void setDate(DateTime date) {
    _form.date = date;
    _view.onDidSelectDate();
  }

  void selectMainCategoryAtIndex(int index) {
    var selectedCategory = _categories[index];
    _form.mainCategory = selectedCategory;
    _view.onDidSelectMainCategory();

    if (selectedCategory.projects.isNotEmpty) {
      selectProjectAtIndex(0);
    }

    if (selectedCategory.subCategories.isNotEmpty) {
      selectSubCategoryAtIndex(0);
    }
  }

  void selectProjectAtIndex(int index) {
    _form.project = _form.mainCategory!.projects[index];
    _view.onDidSelectProject();
  }

  void selectSubCategoryAtIndex(int index) {
    _form.subCategory = _form.mainCategory!.subCategories[index];
    _view.onDidSelectSubCategory();
  }

  void setRate(String rateString) {
    try {
      var rate = Money.fromString(rateString);
      _form.rate = rate;
    } on MoneyInitializationException catch (_) {
      _form.rate = null;
    }
    _validateRate();
    _view.updateTotalAmount();
  }

  void setQuantity(String quantity) {
    try {
      _form.quantity = int.parse(quantity);
    } on FormatException catch (_) {
      _form.quantity = null;
    }
    _validateQuantity();
    _view.updateTotalAmount();
  }

  void addAttachment(File? file) {
    _model.file = file;
    _view.onDidAddAttachment();
  }

  void removeAttachment() {
    _model.file = null;
    _view.onDidRemoveAttachment();
  }

  void setDescription(String description) {
    _form.description = description;
  }

  //MARK: Functions to create expense request

  createExpenseRequest() async {
    if (_requestCreator.isLoading) return;
    if (!_isInputValid()) return;

    _view.showFormSubmissionLoader();
    try {
      await _requestCreator.create(_form, _model.file);
      _view.onDidSubmitFormSuccessfully("Success", "Your expense request has been submitted successfully.");
    } on WPException catch (e) {
      _view.onDidFailToSubmitForm("Failed to create expense request", e.userReadableMessage);
    }
  }

  //MARK: Functions to validate input

  bool _isInputValid() {
    var isValid = true;

    if (!_validateRate()) isValid = false;
    if (!_validateQuantity()) isValid = false;

    return isValid;
  }

  bool _validateRate() {
    var validationResult = _form.validateRate();
    _model.rateError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  bool _validateQuantity() {
    var validationResult = _form.validateQuantity();
    _model.quantityError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  //MARK: Getters

  bool isLoadingExpenseCategories() {
    return _categoriesProvider.isLoading;
  }

  bool isFormSubmissionInProgress() {
    return _requestCreator.isLoading;
  }

  DateTime getDate() {
    return _form.date!;
  }

  String getDateString() {
    return _form.date!.toReadableString();
  }

  List<String> getMainCategoryNames() {
    return _categories.map((category) => category.name).toList();
  }

  List<String> getDisabledMainCategoryNames() {
    return _categories.where((category) => category.isDisabled).map((category) => category.name).toList();
  }

  List<String> getSubCategoryNamesForSelectedMainCategory() {
    if (_form.mainCategory == null) return [];

    return _form.mainCategory!.subCategories.map((category) => category.name).toList();
  }

  List<String> getProjectNamesForSelectedMainCategory() {
    if (_form.mainCategory == null) return [];

    return _form.mainCategory!.projects.map((project) => project.name).toList();
  }

  String getSelectedMainCategoryName() {
    return _form.mainCategory?.name ?? "";
  }

  String getSelectedProjectName() {
    return _form.project?.name ?? "";
  }

  String getSelectedSubCategoryName() {
    return _form.subCategory?.name ?? "";
  }

  bool shouldShowProjects() {
    if (_form.mainCategory == null) return false;

    return _form.mainCategory!.projects.length > 0;
  }

  bool shouldShowSubCategories() {
    if (_form.mainCategory == null) return false;

    return _form.mainCategory!.subCategories.length > 0;
  }

  String getTotalAmount() {
    if (_form.quantity == null || _form.quantity == 0 || _form.rate == null || _form.rate == Money.zero()) return "";

    var currency = _companyProvider.getSelectedCompanyForCurrentUser().currency;
    var totalAmount = _form.rate!.multiply(_form.quantity!);
    return "$currency ${totalAmount.toString()}";
  }

  File? getAttachedFile() {
    return _model.file;
  }

  String getDescription() {
    return _form.description ?? "";
  }

  bool shouldShowLoadCategoriesError() {
    return _model.loadCategoriesError != null;
  }

  String getLoadCategoriesError() {
    return _model.loadCategoriesError ?? "";
  }

  String? getRateError() {
    return _model.rateError;
  }

  String? getQuantityError() {
    return _model.quantityError;
  }
}
