import 'dart:core';
import 'dart:io';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/extensions/file_extension.dart';
import 'package:wallpost/leave/leave_create/entities/leave_request_form.dart';
import 'package:wallpost/leave/leave_create/entities/leave_specs.dart';
import 'package:wallpost/leave/leave_create/services/leave_creator.dart';
import 'package:wallpost/leave/leave_create/services/leave_specs_provider.dart';
import 'package:wallpost/leave/leave_create/ui/models/leave_model.dart';
import 'package:wallpost/leave/leave_create/ui/view_contracts/create_leave_view.dart';

class CreateLeavePresenter {
  CreateLeaveView _view;
  LeaveSpecsProvider _leaveSpecsProvider;
  LeaveCreator _requestCreator;
  late LeaveSpecs _leaveSpecs;
  final _form = LeaveRequestForm();
  var _viewModel = LeaveModel();

  CreateLeavePresenter(this._view)
      : _leaveSpecsProvider = LeaveSpecsProvider(),
        _requestCreator = LeaveCreator();

  CreateLeavePresenter.initWith(
    this._view,
    this._leaveSpecsProvider,
    this._requestCreator,
  );

  //MARK: Functions to load leave specs

  Future<void> loadLeaveSpecs() async {
    if (_leaveSpecsProvider.isLoading) return;

    _viewModel.loadLeaveSpecsError = null;
    _view.showLeaveSpecsLoader();

    try {
      var leaveSpecs = await _leaveSpecsProvider.get();
      _processResponse(leaveSpecs);
    } on WPException catch (e) {
      _viewModel.loadLeaveSpecsError = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadLeaveSpecs();
    }
  }

  void _processResponse(LeaveSpecs leaveSpecs) {
    _leaveSpecs = leaveSpecs;

    if (_leaveSpecs.leaveTypes.isNotEmpty) {
      _view.onDidLoadLeaveSpecs();
      selectLeaveTypeAtIndex(0);
      setLeaveStartDate(DateTime.now());
      setLeaveEndDate(DateTime.now());
    } else {
      _viewModel.loadLeaveSpecsError = "There are no leave types to show.\n\nTap here to reload.";
      _view.onDidFailToLoadLeaveSpecs();
    }
  }

  //MARK: Function to select form data

  void selectLeaveTypeAtIndex(int index) {
    _form.leaveType = _leaveSpecs.leaveTypes[index];
    _view.onDidSelectLeaveType();
  }

  void setLeaveStartDate(DateTime startDate) {
    _form.startDate = startDate;
    _view.onDidSelectStartDate();
    _validateEndDate();
  }

  void setLeaveEndDate(DateTime endDate) {
    _form.endDate = endDate;
    _view.onDidSelectEndDate();
    _validateEndDate();
  }

  void setPhoneNumber(String phoneNumber) {
    _form.phoneNumber = phoneNumber;
  }

  void setEmail(String email) {
    _form.email = email;
  }

  void setLeaveReason(String leaveReason) {
    _form.leaveReason = leaveReason;
  }

  void addAttachment(File file) {
    _viewModel.attachment = file;
    _form.attachedFileName = file.name();
    _view.onDidAddAttachment();
    _validateAttachment();
  }

  void removeAttachment() {
    _viewModel.attachment = null;
    _form.attachedFileName = null;
    _view.onDidRemoveAttachment();
  }

  //MARK: Functions to create leave

  Future<void> createLeave() async {
    if (_requestCreator.isLoading) return;
    if (!_isInputValid()) return;

    _view.showFormSubmissionLoader();
    try {
      await _requestCreator.create(_form, _viewModel.attachment);
      _view.onDidSubmitFormSuccessfully("Success", "Your leave request has been submitted successfully.");
    } on WPException catch (e) {
      _view.onDidFailToSubmitForm("Failed to create leave request", e.userReadableMessage);
    }
  }

  //MARK: Functions to validate input

  bool _isInputValid() {
    var isValid = true;
    if (!_validateEndDate()) isValid = false;
    if (!_validatePhoneNumber()) isValid = false;
    if (!_validateEmail()) isValid = false;
    if (!_validateLeaveReason()) isValid = false;
    if (!_validateAttachment()) isValid = false;
    return isValid;
  }

  bool _validateEndDate() {
    var validationResult = _form.validateEndDate();
    _viewModel.endDateError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  bool _validatePhoneNumber() {
    var validationResult = _form.validatePhoneNumber();
    _viewModel.phoneNumberError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  bool _validateEmail() {
    var validationResult = _form.validateEmail();
    _viewModel.emailError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  bool _validateLeaveReason() {
    var validationResult = _form.validateLeaveReason();
    _viewModel.leaveReasonError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  bool _validateAttachment() {
    var validationResult = _form.validateFileAttachment();
    _viewModel.fileAttachmentError = validationResult.validationErrorMessage;
    _view.updateValidationErrors();
    return validationResult.isValid;
  }

  //MARK: Getters

  bool isLoadingLeaveSpecs() => _leaveSpecsProvider.isLoading;

  bool isFormSubmissionInProgress() => _requestCreator.isLoading;

  List<String> getLeaveTypeNames() => _leaveSpecs.leaveTypes.map((leaveType) => leaveType.name).toList();

  String getSelectedLeaveTypeName() => _form.leaveType?.name ?? "";

  DateTime? getLeaveStartDate() => _form.startDate;

  DateTime? getLeaveEndDate() => _form.endDate;

  String getStartDateString() => _form.startDate?.toReadableString() ?? "";

  String getEndDateString() => _form.endDate?.toReadableString() ?? "";

  String getPhoneNumber() => _form.phoneNumber ?? "";

  String getEmail() => _form.email ?? "";

  String getLeaveReason() => _form.leaveReason ?? "";

  File? getAttachedFile() => _viewModel.attachment;

  bool shouldShowLoadLeaveSpecsError() => _viewModel.loadLeaveSpecsError != null;

  String getLoadLeaveSpecsError() => _viewModel.loadLeaveSpecsError ?? "";

  String? getEndDateError() => _viewModel.endDateError;

  String? getPhoneNumberError() => _viewModel.phoneNumberError;

  String? getEmailError() => _viewModel.emailError;

  String? getLeaveReasonError() => _viewModel.leaveReasonError;

  String? getFileAttachmentError() => _viewModel.fileAttachmentError;
}
