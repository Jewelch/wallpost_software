import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/attendance/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance/attendance_adjustment/services/adjusted_status_provider.dart';
import 'package:wallpost/attendance/attendance_adjustment/services/attendance_adjustment_submitter.dart';
import 'package:wallpost/attendance/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../../attendance__core/utils/attendance_status_color.dart';

class AttendanceAdjustmentPresenter {
  final AttendanceAdjustmentView _view;
  final AttendanceListItem _attendanceListItem;
  final AdjustedStatusProvider _adjustedStatusProvider;
  final AttendanceAdjustmentSubmitter _adjustmentSubmitter;
  final SelectedCompanyProvider _selectedCompanyProvider;

  final TimeOfDay? _punchInTime;
  final TimeOfDay? _punchOutTime;
  late TimeOfDay? _adjustedPunchInTime;
  late TimeOfDay? _adjustedPunchOutTime;
  late AttendanceStatus _adjustedStatus;

  String? _adjustedTimeError;
  String? _reasonError;

  AttendanceAdjustmentPresenter(this._view, this._attendanceListItem)
      : _adjustmentSubmitter = AttendanceAdjustmentSubmitter(),
        _adjustedStatusProvider = AdjustedStatusProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider(),
        _punchInTime = _readTime(_attendanceListItem.punchInTime),
        _punchOutTime = _readTime(_attendanceListItem.punchOutTime) {
    _initAttendanceDetails();
  }

  AttendanceAdjustmentPresenter.initWith(
    this._view,
    this._attendanceListItem,
    this._adjustedStatusProvider,
    this._adjustmentSubmitter,
    this._selectedCompanyProvider,
  )   : _punchInTime = _readTime(_attendanceListItem.punchInTime),
        _punchOutTime = _readTime(_attendanceListItem.punchOutTime) {
    _initAttendanceDetails();
  }

  static TimeOfDay? _readTime(DateTime? time) {
    if (time == null) return null;

    return TimeOfDay.fromDateTime(time);
  }

  void _initAttendanceDetails() {
    _adjustedPunchInTime = _punchInTime;
    _adjustedPunchOutTime = _punchOutTime;
    _adjustedStatus = _attendanceListItem.status;
  }

  //MARK: Functions to load adjusted status

  Future<void> loadAdjustedStatus({TimeOfDay? adjustedPunchInTime, TimeOfDay? adjustedPunchOutTime}) async {
    if (_adjustedStatusProvider.isLoading) return;

    var previouslySelectedPunchInTime = _adjustedPunchInTime;
    var previouslySelectedPunchOutTime = _adjustedPunchOutTime;
    if (adjustedPunchInTime != null) this._adjustedPunchInTime = adjustedPunchInTime;
    if (adjustedPunchOutTime != null) this._adjustedPunchOutTime = adjustedPunchOutTime;
    _clearAdjustedTimeError();
    _view.updateAdjustedPunchInAndOutTime();
    _view.showAdjustedStatusLoader();

    try {
      var form = AdjustedStatusForm(_attendanceListItem.date, _adjustedPunchInTime, _adjustedPunchOutTime);
      _adjustedStatus = await _adjustedStatusProvider.getAdjustedStatus(form);
      _view.onDidLoadAdjustedStatus();
    } on WPException catch (e) {
      _adjustedPunchInTime = previouslySelectedPunchInTime;
      _adjustedPunchOutTime = previouslySelectedPunchOutTime;
      _view.updateAdjustedPunchInAndOutTime();
      _view.onDidFailToLoadAdjustedStatus("Failed to load adjusted status", e.userReadableMessage);
    }
  }

  //MARK: Function to submit adjusted attendance

  Future<void> submitAdjustment(String reason) async {
    if (_adjustmentSubmitter.isLoading) return;
    _clearAdjustedTimeError();
    _clearReasonError();
    if (!_isInputValid(reason)) return;

    try {
      var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
      var employee = company.employee;
      var attendanceAdjustmentForm = AttendanceAdjustmentForm(
        _attendanceListItem.attendanceId,
        company.id,
        employee.v1Id,
        _attendanceListItem.date,
        reason,
        _adjustedPunchInTime,
        _adjustedPunchOutTime,
        _adjustedStatus,
      );
      _view.showFormSubmissionLoader();
      await _adjustmentSubmitter.submitAdjustment(attendanceAdjustmentForm);
      _view.onDidAdjustAttendanceSuccessfully("Adjustment Successful", "Attendance has been adjusted successfully.");
    } on WPException catch (e) {
      _view.onDidFailToAdjustAttendance("Adjustment Failed", e.userReadableMessage);
    }
  }

  bool _isInputValid(String reason) {
    var isValid = true;

    if (_adjustedPunchInTime == null) {
      isValid = false;
      _adjustedTimeError = "Please select adjusted punch in time";
      _view.notifyNoAdjustmentMade();
    } else if (_adjustedPunchOutTime == null) {
      isValid = false;
      _adjustedTimeError = "Please select adjusted punch out time";
      _view.notifyNoAdjustmentMade();
    }

    if (reason.isEmpty) {
      isValid = false;
      _reasonError = "Please enter a reason";
      _view.notifyInvalidReason();
    }

    return isValid;
  }

  //MARK: Functions to clear errors

  void _clearAdjustedTimeError() {
    _adjustedTimeError = null;
    _view.clearAdjustedTimeInputError();
  }

  void _clearReasonError() {
    _reasonError = null;
    _view.clearReasonInputError();
  }

  //MARK: Getters

  bool shouldDisableFormEntry() {
    return _attendanceListItem.isApprovalPending() ||
        _adjustedStatusProvider.isLoading ||
        _adjustmentSubmitter.isLoading;
  }

  String getAttendanceDate() {
    var dateFormat = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().dateFormat;
    return DateFormat(dateFormat).format(_attendanceListItem.date);
  }

  String getAdjustedStatus() {
    return _adjustedStatus.toReadableString();
  }

  Color getAdjustedStatusColor() {
    return AttendanceStatusColor.getStatusColor(_adjustedStatus);
  }

  String getApprovalInfo() {
    if (_attendanceListItem.isApprovalPending() && _attendanceListItem.approverName != null) {
      return "Pending Approval with ${_attendanceListItem.approverName}";
    }

    return "";
  }

  String getPunchInTimeString() {
    if (_punchInTime == null) return "No Punch In";

    return _punchInTime!.hhmmaString();
  }

  String getPunchOutTimeString() {
    if (_punchOutTime == null) return "No Punch Out";

    return _punchOutTime!.hhmmaString();
  }

  String getAdjustedPunchInTimeString() {
    return _adjustedPunchInTime?.hhmmaString() ?? "";
  }

  String getAdjustedPunchOutTimeString() {
    return _adjustedPunchOutTime?.hhmmaString() ?? "";
  }

  String? getReason() {
    return _attendanceListItem.adjustmentReason;
  }

  String? getAdjustedTimeError() {
    return _adjustedTimeError;
  }

  String? getReasonError() {
    return _reasonError;
  }

  bool isLoadingAdjustedStatus() {
    return _adjustedStatusProvider.isLoading;
  }

  bool isSubmittingAdjustment() {
    return _adjustmentSubmitter.isLoading;
  }

  TimeOfDay get adjustedPunchInTime => _adjustedPunchInTime ?? TimeOfDay(hour: 0, minute: 0);

  TimeOfDay get adjustedPunchOutTime => _adjustedPunchOutTime ?? TimeOfDay(hour: 0, minute: 0);
}
