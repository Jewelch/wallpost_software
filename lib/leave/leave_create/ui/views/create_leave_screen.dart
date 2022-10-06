import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/filter_views/dropdown_filter.dart';
import 'package:wallpost/_common_widgets/form_widgets/file_field.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_date_field.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/leave/leave_create/ui/views/create_leave_loader.dart';

import '../../../../_common_widgets/alert/alert.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../presenters/create_leave_presenter.dart';
import '../view_contracts/create_leave_view.dart';

class CreateLeaveScreen extends StatefulWidget {
  @override
  State<CreateLeaveScreen> createState() => _CreateLeaveScreenState();
}

class _CreateLeaveScreenState extends State<CreateLeaveScreen> implements CreateLeaveView {
  late final CreateLeavePresenter _presenter;

  @override
  void initState() {
    _presenter = CreateLeavePresenter(this);
    _presenter.loadLeaveSpecs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: SimpleAppBar(
        title: "Leave Request",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(child: _mainView()),
    );
  }

  Widget _mainView() {
    if (_presenter.isLoadingLeaveSpecs()) {
      return CreateLeaveLoader();
    } else if (_presenter.shouldShowLoadLeaveSpecsError()) {
      return _buildErrorView();
    } else {
      return _buildFormView();
    }
  }

  Widget _buildErrorView() {
    return GestureDetector(
      onTap: () => _presenter.loadLeaveSpecs(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            _presenter.getLoadLeaveSpecsError(),
            textAlign: TextAlign.center,
            style: TextStyles.titleTextStyle,
          ),
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

  Widget _form() {
    return AbsorbPointer(
      absorbing: _presenter.isFormSubmissionInProgress() ? true : false,
      child: ListView(
        children: [
          SizedBox(height: 24),
          _leaveTypeSelector(),
          SizedBox(height: 24),
          _startDateSelector(),
          SizedBox(height: 24),
          _endDateSelector(),
          SizedBox(height: 24),
          _phoneNumberTextField(),
          SizedBox(height: 24),
          _emailTextField(),
          SizedBox(height: 24),
          _fileSelector(),
          SizedBox(height: 24),
          _leaveReasonTextField(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _leaveTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Select the leave type", isMandatory: true),
        SizedBox(height: 2),
        DropdownFilter(
          items: _presenter.getLeaveTypeNames(),
          selectedValue: _presenter.getSelectedLeaveTypeName(),
          hint: "Leave Type",
          onDidSelectedItemAtIndex: (index) => _presenter.selectLeaveTypeAtIndex(index),
          backgroundColor: AppColors.textFieldBackgroundColor,
          textStyle: TextStyles.titleTextStyle,
          dropdownArrowColor: AppColors.textColorBlack,
        ),
      ],
    );
  }

  Widget _startDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Leave start date", isMandatory: true),
        SizedBox(height: 2),
        FormDateField(
          initialDate: _presenter.getLeaveStartDate() ?? DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 600)),
          lastDate: DateTime.now().add(Duration(days: 600)),
          onDateSelected: (date) => _presenter.setLeaveStartDate(date),
        ),
      ],
    );
  }

  Widget _endDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Leave end date", isMandatory: true),
        SizedBox(height: 2),
        FormDateField(
          initialDate: _presenter.getLeaveEndDate() ?? DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 600)),
          lastDate: DateTime.now().add(Duration(days: 600)),
          onDateSelected: (date) => _presenter.setLeaveEndDate(date),
          errorText: _presenter.getEndDateError(),
        ),
      ],
    );
  }

  Widget _phoneNumberTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Contact number during leave", isMandatory: true),
        SizedBox(height: 2),
        FormTextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (phoneNumber) => _presenter.setPhoneNumber(phoneNumber),
          errorText: _presenter.getPhoneNumberError(),
        ),
      ],
    );
  }

  Widget _emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Email during leave", isMandatory: true),
        SizedBox(height: 2),
        FormTextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (email) => _presenter.setEmail(email),
          errorText: _presenter.getEmailError(),
        ),
      ],
    );
  }

  Widget _leaveReasonTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formFieldLabel("Leave reason", isMandatory: true),
        SizedBox(height: 2),
        FormTextField(
          minLines: 3,
          maxLines: 5,
          keyboardType: TextInputType.text,
          onChanged: (reason) => _presenter.setLeaveReason(reason),
          errorText: _presenter.getLeaveReasonError(),
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
        FileField(
          selectedFile: _presenter.getAttachedFile(),
          onFileSelected: (selectedFile) => _presenter.addAttachment(selectedFile),
          onRemoveButtonPress: () => _presenter.removeAttachment(),
          errorText: _presenter.getFileAttachmentError(),
        ),
      ],
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
        _presenter.createLeave();
      },
    );
  }

  //MARK: View functions

  @override
  void showLeaveSpecsLoader() {
    setState(() {});
  }

  @override
  void onDidFailToLoadLeaveSpecs() {
    setState(() {});
  }

  @override
  void onDidLoadLeaveSpecs() {
    setState(() {});
  }

  @override
  void onDidSelectLeaveType() {
    setState(() {});
  }

  @override
  void onDidSelectStartDate() {
    setState(() {});
  }

  @override
  void onDidSelectEndDate() {
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
  void updateValidationErrors() {
    setState(() {});
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
