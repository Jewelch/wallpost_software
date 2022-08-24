import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/file_picker/file_picker_screen.dart';
import 'package:wallpost/_common_widgets/filter_views/dropdown_filter.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_create/ui/presenters/expense_request_presenter.dart';
import 'package:wallpost/expense_create/ui/view_contracts/expense_request_form_view.dart';
import 'package:wallpost/expense_create/ui/views/expense_request_loader.dart';

import '../../../_common_widgets/alert/alert.dart';
import '../../../_common_widgets/text_styles/text_styles.dart';

class CreateExpenseRequestScreen extends StatefulWidget {
  @override
  State<CreateExpenseRequestScreen> createState() => _CreateExpenseRequestScreenState();
}

class _CreateExpenseRequestScreenState extends State<CreateExpenseRequestScreen> implements ExpenseRequestFormView {
  TextEditingController _totalAmountController = TextEditingController();
  late final ExpenseRequestPresenter _presenter;

  @override
  void initState() {
    _presenter = ExpenseRequestPresenter(this);
    _presenter.loadCategories();
    super.initState();
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
      body: SafeArea(child: _mainView()),
    );
  }

  Widget _mainView() {
    if (_presenter.isLoadingExpenseCategories()) {
      return ExpenseRequestLoader();
    } else if (_presenter.shouldShowLoadCategoriesError()) {
      return _buildErrorView();
    } else {
      return _buildFormView();
    }
  }

  Widget _buildErrorView() {
    return GestureDetector(
      onTap: () => _presenter.loadCategories(),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 100,
          child: Text(_presenter.getLoadCategoriesError()),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return OnTapKeyboardDismisser(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Expanded(child: _form()),
            SizedBox(height: 12),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _dateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Date", isMandatory: true),
        SizedBox(height: 2),
        GestureDetector(
          onTap: () async {
            KeyboardDismisser.dismissKeyboard();
            var date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 600)),
                lastDate: DateTime.now().add(Duration(days: 600)));
            if (date != null) _presenter.setDate(date);
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration:
                BoxDecoration(color: AppColors.textFieldBackgroundColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Expanded(child: Text(_presenter.getDateString(), style: TextStyles.titleTextStyle)),
                Icon(Icons.calendar_today_outlined, color: AppColors.textColorGray),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _categorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Select the type of expense", isMandatory: true),
        SizedBox(height: 2),
        DropdownFilter(
          items: _presenter.getMainCategoryNames(),
          disabledItems: _presenter.getDisabledMainCategoryNames(),
          selectedValue: _presenter.getSelectedMainCategoryName(),
          onDidSelectedItemAtIndex: (index) => _presenter.selectMainCategoryAtIndex(index),
          backgroundColor: AppColors.textFieldBackgroundColor,
          textStyle: TextStyles.titleTextStyle,
          dropdownArrowColor: AppColors.textColorBlack,
        ),
        if (_presenter.shouldShowProjects()) SizedBox(height: 12),
        if (_presenter.shouldShowProjects())
          DropdownFilter(
            items: _presenter.getProjectNamesForSelectedMainCategory(),
            selectedValue: _presenter.getSelectedProjectName(),
            onDidSelectedItemAtIndex: (index) => _presenter.selectProjectAtIndex(index),
            backgroundColor: AppColors.textFieldBackgroundColor,
            textStyle: TextStyles.titleTextStyle,
            dropdownArrowColor: AppColors.textColorBlack,
          ),
        if (_presenter.shouldShowSubCategories()) SizedBox(height: 12),
        if (_presenter.shouldShowSubCategories())
          DropdownFilter(
            items: _presenter.getSubCategoryNamesForSelectedMainCategory(),
            selectedValue: _presenter.getSelectedSubCategoryName(),
            onDidSelectedItemAtIndex: (index) => _presenter.selectSubCategoryAtIndex(index),
            backgroundColor: AppColors.textFieldBackgroundColor,
            textStyle: TextStyles.titleTextStyle,
            dropdownArrowColor: AppColors.textColorBlack,
          ),
      ],
    );
  }

  Widget _expenseRateTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Enter the rate", isMandatory: true),
        SizedBox(height: 2),
        FormTextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (rate) => _presenter.setRate(rate),
          errorText: _presenter.getRateError(),
        ),
      ],
    );
  }

  Widget _quantityTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Enter the quantity", isMandatory: true),
        SizedBox(height: 2),
        FormTextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (quantity) => _presenter.setQuantity(quantity),
          errorText: _presenter.getQuantityError(),
        ),
      ],
    );
  }

  Widget _totalAmountTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Total amount to claim is"),
        SizedBox(height: 2),
        FormTextField(
          isEnabled: false,
          controller: _totalAmountController,
        ),
      ],
    );
  }

  Widget _fileSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Upload supporting documents"),
        SizedBox(height: 2),
        GestureDetector(
          onTap: () async {
            var files = await FilePickerScreen.present(context);
            if (files != null && files is List && files.isNotEmpty) _presenter.addAttachment(files[0]);
          },
          child: Container(
            height: 50,
            decoration:
                BoxDecoration(color: AppColors.textFieldBackgroundColor, borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(child: Text(_presenter.getAttachedFileName(), style: TextStyles.titleTextStyle)),
                Icon(Icons.attachment, color: AppColors.textColorGray),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Description"),
        SizedBox(height: 2),
        FormTextField(
          minLines: 3,
          maxLines: 5,
          keyboardType: TextInputType.text,
          onChanged: (description) => _presenter.setDescription(description),
        ),
      ],
    );
  }

  Widget _form() {
    return AbsorbPointer(
      absorbing: _presenter.isFormSubmissionInProgress() ? true : false,
      child: ListView(
        children: [
          SizedBox(height: 24),
          _dateSelector(),
          SizedBox(height: 24),
          _categorySelector(),
          SizedBox(height: 24),
          _expenseRateTextField(),
          SizedBox(height: 24),
          _quantityTextField(),
          SizedBox(height: 24),
          _totalAmountTextField(),
          SizedBox(height: 24),
          _fileSelector(),
          SizedBox(height: 24),
          _descriptionTextField(),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _formFieldLabel(String text, {bool isMandatory = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 4),
          Text(text, style: TextStyles.titleTextStyleBold),
          if (isMandatory)
            Text(
              "*",
              style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.red),
            ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return RoundedRectangleActionButton(
      title: "Save",
      showLoader: _presenter.isFormSubmissionInProgress() ? true : false,
      backgroundColor: AppColors.green,
      onPressed: () {
        KeyboardDismisser.dismissKeyboard();
        _presenter.createExpenseRequest();
      },
    );
  }

  //MARK: View functions

  @override
  void showCategoriesLoader() {
    setState(() {});
  }

  @override
  void onDidFailToLoadCategories() {
    setState(() {});
  }

  @override
  void onDidLoadCategories() {
    setState(() {});
  }

  @override
  void onDidAddAttachment() {
    setState(() {});
  }

  @override
  void onDidRemoveAttachment() {
    setState(() {});
  }

  @override
  void onDidSelectMainCategory() {
    setState(() {});
  }

  @override
  void onDidSelectProject() {
    setState(() {});
  }

  @override
  void onDidSelectSubCategory() {
    setState(() {});
  }

  @override
  void onDidSetDate() {
    setState(() {});
  }

  @override
  void updateValidationErrors() {
    setState(() {});
  }

  @override
  void updateTotalAmount() {
    _totalAmountController.text = _presenter.getTotalAmount();
  }

  @override
  void showFormSubmissionLoader() {
    setState(() {});
  }

  @override
  void onDidFailToSubmitForm(String title, String message) {
    setState(() {});
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onDidSubmitFormSuccessfully(String title, String message) {
    Alert.showSimpleAlert(
      context: context,
      title: title,
      message: message,
      onPressed: () => Navigator.pop(context, true),
    );
  }
}
