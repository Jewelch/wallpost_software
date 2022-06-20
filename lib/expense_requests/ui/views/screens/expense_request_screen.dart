import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/file_picker/file_picker_screen.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/file_extension.dart';
import 'package:wallpost/expense_requests/entities/expense_category.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_form_validator.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_model.dart';
import 'package:wallpost/expense_requests/ui/models/expense_request_form_view_type.dart';
import 'package:wallpost/expense_requests/ui/presenters/expense_request_presenter.dart';
import 'package:wallpost/expense_requests/ui/view_contracts/expense_requests_view.dart';
import 'package:wallpost/expense_requests/ui/views/widgets/expense_date_selector.dart';
import 'package:wallpost/expense_requests/ui/views/widgets/expense_input_with_header.dart';
import 'package:wallpost/expense_requests/ui/views/widgets/expense_main_category_selector.dart';
import 'package:wallpost/expense_requests/ui/views/widgets/expense_request_loader.dart';
import 'package:wallpost/expense_requests/ui/views/widgets/expense_request_upload_success.dart';

class ExpenseRequestScreen extends StatefulWidget {
  @override
  State<ExpenseRequestScreen> createState() => _ExpenseRequestScreenState();
}

class _ExpenseRequestScreenState extends State<ExpenseRequestScreen>
    implements ExpenseRequestsView {
  final ItemNotifier<ExpenseRequestFormViewType> _viewTypeNotifier =
      ItemNotifier(defaultValue: ExpenseRequestFormViewType.loader);
  final ItemNotifier<bool> _showLoaderNotifier = ItemNotifier(defaultValue: false);
  final ItemNotifier<bool> _screenFreezingNotifier = ItemNotifier(defaultValue: false);

  final ItemNotifier<bool> _subCategoriesNotifier = ItemNotifier(defaultValue: false);
  final ItemNotifier<bool> _projectsNotifier = ItemNotifier(defaultValue: false);
  final ItemNotifier<void> _totalNotifier = ItemNotifier(defaultValue: null);
  late final ItemNotifier<ExpenseRequestFormValidator> _validationNotifier;

  String _errorMessage = "";

  final _expenseRequest = ExpenseRequestModel();

  late final ExpenseRequestPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _validationNotifier = ItemNotifier(defaultValue: ExpenseRequestFormValidator(_expenseRequest));
    _presenter = ExpenseRequestPresenter(this);
    _presenter.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: SimpleAppBar(
        title: "Expense Request",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable<ExpenseRequestFormViewType>(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            switch (viewType) {
              case ExpenseRequestFormViewType.loader:
                return ExpenseRequestLoader();
              case ExpenseRequestFormViewType.error:
                return _buildErrorView();
              case ExpenseRequestFormViewType.form:
                return _buildFormView();
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return GestureDetector(
      onTap: () => _presenter.getCategories(),
      child: Center(
        child: Container(height: 100, child: Text(_errorMessage)),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      children: [
        Expanded(child: _form()),
        Container(
          height: 80,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Center(child: _saveButton()),
        ),
      ],
    );
  }

  Widget _form() {
    return ItemNotifiable<bool>(
      notifier: _screenFreezingNotifier,
      builder: (_, isLoading) => AbsorbPointer(
        absorbing: isLoading,
        child: ItemNotifiable<ExpenseRequestFormValidator>(
            notifier: _validationNotifier,
            builder: (context, validator) {
              return ListView(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 24),
                children: [
                  ExpenseDateSelector(
                    selectedDate: _expenseRequest.date,
                    onDateSelected: (date) {
                      _expenseRequest.date = date;
                      setState(() {});
                    },
                  ),
                  ExpenseInputWithHeader(
                    missingMessage: validator.mainCategoryMissingError,
                    required: true,
                    title: "Select the type of expense",
                    child: ExpenseCategorySelector(
                      items: _presenter.expenseRequests,
                      onChanged: (mainCategory) {
                        _expenseRequest.selectedMainCategory = mainCategory;
                        if (mainCategory != null) {
                          _presenter.selectCategory(mainCategory);
                        }
                      },
                      value: () => _expenseRequest.selectedMainCategory,
                    ),
                  ),
                  ItemNotifiable<bool>(
                    notifier: _subCategoriesNotifier,
                    builder: (_, hasSubCategory) => hasSubCategory
                        ? ExpenseInputWithHeader(
                            missingMessage: validator.subCategoryMissingError,
                            required: true,
                            title: "Select the sub type of expense",
                            child: ExpenseCategorySelector(
                              items: _expenseRequest.selectedMainCategory!.subCategories,
                              onChanged: (subCategory) {
                                _expenseRequest.selectedSubCategory = subCategory;
                              },
                              value: () => _expenseRequest.selectedSubCategory,
                            ),
                          )
                        : SizedBox(),
                  ),
                  ItemNotifiable<bool>(
                    notifier: _projectsNotifier,
                    builder: (_, hasProject) {
                      return hasProject
                          ? ExpenseInputWithHeader(
                              missingMessage: validator.projectMissingError,
                              required: true,
                              title: "Select the project",
                              child: ExpenseCategorySelector(
                                items: _expenseRequest.selectedMainCategory!.projects,
                                onChanged: (project) => _expenseRequest.selectedProject = project,
                                value: () => _expenseRequest.selectedProject,
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                  ExpenseInputWithHeader(
                    required: true,
                    missingMessage: validator.amountMissingError,
                    title: "Enter the expense amount",
                    child: TextField(
                      decoration: InputDecoration(
                        enabled: !isLoading,
                        border: InputBorder.none,
                        hintText: _expenseRequest.amount,
                        hintStyle: TextStyle(color: AppColors.darkGrey),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _expenseRequest.setAmount(value);
                        _totalNotifier.notify(null);
                      },
                    ),
                  ),
                  ExpenseInputWithHeader(
                    required: true,
                    missingMessage: validator.quantityMissingError,
                    title: "Enter the total quantity",
                    child: TextField(
                      enabled: !isLoading,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _expenseRequest.quantity.toString(),
                        hintStyle: TextStyle(color: AppColors.darkGrey),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _expenseRequest.setQuantity(value);
                        _totalNotifier.notify(null);
                      },
                    ),
                  ),
                  ExpenseInputWithHeader(
                    title: "Total amount to claim is",
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ItemNotifiable(
                        notifier: _totalNotifier,
                        builder: (c, f) => Text(
                          _expenseRequest.total.toString(),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var files = await FilePickerScreen.present(context,
                          filesType: [FileTypes.documents, FileTypes.images, FileTypes.camera]);
                      if (files == null) return;
                      if ((files as List).isNotEmpty) _expenseRequest.file = files[0];
                      setState(() {});
                    },
                    child: ExpenseInputWithHeader(
                      required: true,
                      missingMessage: validator.fileMissingError,
                      title: "Upload supporting document",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _expenseRequest.file != null ? _expenseRequest.file!.name() : "",
                              style: TextStyle(color: AppColors.darkGrey),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _expenseRequest.file == null
                                  ? Icon(
                                      Icons.attach_file,
                                      color: AppColors.darkGrey,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        _expenseRequest.file = null;
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: AppColors.darkGrey,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ExpenseInputWithHeader(
                    height: 100,
                    title: "Remarks",
                    child: TextField(
                      enabled: !isLoading,
                      minLines: 3,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: _expenseRequest.description.toString(),
                        hintStyle: TextStyle(color: AppColors.darkGrey),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _expenseRequest.description = value,
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  Widget _saveButton() {
    return ItemNotifiable<bool>(
        notifier: _showLoaderNotifier,
        builder: (context, isLoading) {
          return RoundedRectangleActionButton(
            title: "Save",
            showLoader: isLoading,
            backgroundColor: AppColors.greenButtonColor,
            onPressed: () {
              _presenter.sendExpenseRequest(_expenseRequest);
            },
          );
        });
  }

  // MARK: view functions

  @override
  void onStartFetchCategories() {
    _viewTypeNotifier.notify(ExpenseRequestFormViewType.loader);
  }

  @override
  void onFetchCategoriesSuccessfully() {
    _viewTypeNotifier.notify(ExpenseRequestFormViewType.form);
  }

  @override
  void onFieldToFetchCategories(String userReadableMessage) {
    _viewTypeNotifier.notify(ExpenseRequestFormViewType.error);
    _errorMessage = userReadableMessage;
  }

  @override
  void showSubCategories(List<ExpenseCategory> subCategories) {
    _expenseRequest.selectedSubCategory = null;
    _subCategoriesNotifier.notify(true);
  }

  @override
  void hideSubCategoriesView() {
    _subCategoriesNotifier.notify(false);
  }

  @override
  void showProjects(List<ExpenseCategory> projects) {
    _expenseRequest.selectedProject = null;
    _projectsNotifier.notify(true);
  }

  @override
  void hideProjectsView() {
    _projectsNotifier.notify(false);
  }

  @override
  void resetErrors() {
    _validationNotifier.notify(ExpenseRequestFormValidator(_expenseRequest));
  }

  @override
  void notifyValidationErrors(ExpenseRequestFormValidator validator) {
    _validationNotifier.notify(validator);
  }

  @override
  void showLoader() {
    _showLoaderNotifier.notify(true);
    _screenFreezingNotifier.notify(true);
  }

  @override
  void hideLoader() {
    _showLoaderNotifier.notify(false);
    _screenFreezingNotifier.notify(false);
  }

  @override
  void onSendRequestsSuccessfully() {
    ScreenPresenter.present(ExpenseRequestSubmittedSuccessScreen(), context);
  }

  @override
  void showErrorMessage(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }
}
