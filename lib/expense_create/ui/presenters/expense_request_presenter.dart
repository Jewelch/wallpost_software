import 'dart:core';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/_shared/money/money_initialization_exception.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_create/ui/models/expense_request_model.dart';

import '../../entities/expense_category.dart';
import '../../entities/expense_request_form.dart';
import '../../services/expense_categories_provider.dart';
import '../../services/expense_request_creator.dart';
import '../view_contracts/expense_request_form_view.dart';

class ExpenseRequestPresenter {
  ExpenseRequestFormView _view;
  ExpenseCategoriesProvider _categoriesProvider;
  ExpenseRequestCreator _requestCreator;
  SelectedCompanyProvider _companyProvider;
  List<ExpenseCategory> _categories = [];
  var _model = ExpenseRequestModel();

  ExpenseRequestPresenter(this._view)
      : _categoriesProvider = ExpenseCategoriesProvider(),
        _requestCreator = ExpenseRequestCreator(),
        _companyProvider = SelectedCompanyProvider();

  ExpenseRequestPresenter.initWith(
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
      _categories = await _categoriesProvider.get();

      if (_categories.isNotEmpty) {
        _view.onDidLoadCategories();
        selectMainCategoryAtIndex(0);
      } else {
        _model.loadCategoriesError = "There are no categories to show.\n\nTap here to reload.";
        _view.onDidFailToLoadCategories();
      }
    } on WPException catch (e) {
      _model.loadCategoriesError = e.userReadableMessage;
      _view.onDidFailToLoadCategories();
    }
  }

  //MARK: Function to select form data

  void setDate(DateTime date) {
    _model.date = date;
    _view.onDidSetDate();
  }

  void selectMainCategoryAtIndex(int index) {
    var selectedCategory = _categories[index];
    _model.mainCategory = selectedCategory;

    if (selectedCategory.projects.isNotEmpty) {
      _model.project = _model.mainCategory!.projects[0];
    }

    if (selectedCategory.subCategories.isNotEmpty) {
      _model.subCategory = _model.mainCategory!.subCategories[0];
    }

    _view.onDidSelectMainCategory();
  }

  void selectProjectAtIndex(int index) {
    _model.project = _model.mainCategory!.projects[index];
    _view.onDidSelectProject();
  }

  void selectSubCategoryAtIndex(int index) {
    _model.subCategory = _model.mainCategory!.subCategories[index];
    _view.onDidSelectSubCategory();
  }

  void setRate(String rateString) {
    try {
      var rate = Money.fromString(rateString);
      _model.rate = rate;
    } on MoneyInitializationException catch (_) {
      _model.rate = null;
    }
    _validateRate();
    _view.updateTotalAmount();
  }

  bool _validateRate() {
    bool isValid;
    if (_model.rate == null) {
      _model.rateError = "Enter a valid rate";
      isValid = false;
    } else if (_model.rate == Money.zero()) {
      _model.rateError = "Rate cannot be zero";
      isValid = false;
    } else {
      _model.rateError = null;
      isValid = true;
    }

    _view.updateValidationErrors();
    return isValid;
  }

  void setQuantity(String quantity) {
    try {
      _model.quantity = int.parse(quantity);
    } on FormatException catch (_) {
      _model.quantity = null;
    }
    _validateQuantity();
    _view.updateTotalAmount();
  }

  bool _validateQuantity() {
    bool isValid;
    if (_model.quantity == null) {
      _model.quantityError = "Enter a valid quantity";
      isValid = false;
    } else if (_model.quantity == 0) {
      _model.quantityError = "Quantity cannot be zero";
      isValid = false;
    } else {
      _model.quantityError = null;
      isValid = true;
    }

    _view.updateValidationErrors();
    return isValid;
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
    _model.description = description;
  }

  //MARK: Functions to create expense request

  createExpenseRequest() async {
    if (_requestCreator.isLoading) return;
    if (!_isInputValid()) return;

    _view.showFormSubmissionLoader();
    try {
      var expenseForm = _buildExpenseRequestForm();
      await _requestCreator.create(expenseForm, _model.file);
      _view.onDidSubmitFormSuccessfully("Success", "Your expense request has been submitted successfully.");
    } on WPException catch (e) {
      _view.onDidFailToSubmitForm("Failed to create expense request", e.userReadableMessage);
    }
  }

  bool _isInputValid() {
    var isValid = true;

    if (!_validateRate()) isValid = false;
    if (!_validateQuantity()) isValid = false;

    return isValid;
  }

  ExpenseRequestForm _buildExpenseRequestForm() {
    return ExpenseRequestForm(
      date: _model.date,
      mainCategory: _model.mainCategory!,
      subCategory: _model.subCategory,
      project: _model.project,
      rate: _model.rate!,
      quantity: _model.quantity!,
      description: _model.description,
    );
  }

  //MARK: Getters

  bool isLoadingExpenseCategories() {
    return _categoriesProvider.isLoading;
  }

  bool shouldShowLoadCategoriesError() {
    return _model.loadCategoriesError != null;
  }

  DateTime getDate() {
    return _model.date;
  }

  String getDateString() {
    var dateFormat = _companyProvider.getSelectedCompanyForCurrentUser().dateFormat;
    return DateFormat(dateFormat).format(_model.date);
  }

  List<String> getMainCategoryNames() {
    return _categories.map((category) => category.name).toList();
  }

  List<String> getDisabledMainCategoryNames() {
    return _categories.where((category) => category.isDisabled).map((category) => category.name).toList();
  }

  List<String> getSubCategoryNamesForSelectedMainCategory() {
    if (_model.mainCategory == null) return [];

    return _model.mainCategory!.subCategories.map((category) => category.name).toList();
  }

  List<String> getProjectNamesForSelectedMainCategory() {
    if (_model.mainCategory == null) return [];

    return _model.mainCategory!.projects.map((project) => project.name).toList();
  }

  String getSelectedMainCategoryName() {
    return _model.mainCategory?.name ?? "";
  }

  String getSelectedSubCategoryName() {
    return _model.subCategory?.name ?? "";
  }

  String getSelectedProjectName() {
    return _model.project?.name ?? "";
  }

  bool shouldShowSubCategories() {
    if (_model.mainCategory == null) return false;

    return _model.mainCategory!.subCategories.length > 0;
  }

  bool shouldShowProjects() {
    if (_model.mainCategory == null) return false;

    return _model.mainCategory!.projects.length > 0;
  }

  String getQuantity() {
    if (_model.quantity == null) return "";

    return "${_model.quantity}";
  }

  String getRate() {
    if (_model.rate == null) return "";

    var currency = _companyProvider.getSelectedCompanyForCurrentUser().currency;
    return "$currency ${_model.rate!.toString()}";
  }

  String getTotalAmount() {
    if (_model.quantity == null || _model.quantity == 0 || _model.rate == null || _model.rate == Money.zero())
      return "";

    var currency = _companyProvider.getSelectedCompanyForCurrentUser().currency;
    var totalAmount = _model.rate!.multiply(_model.quantity!);
    return "$currency ${totalAmount.toString()}";
  }

  String getAttachedFileName() {
    if (_model.file == null) return "";

    return basename(_model.file!.path);
  }

  String getDescription() {
    return _model.description ?? "";
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

  bool isFormSubmissionInProgress() {
    return _requestCreator.isLoading;
  }
}
