import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class AttendanceAdjustmentPresenter {
  final AttendanceAdjustmentView _view;
  final AttendanceListItem _attendanceListItem;
  final AdjustedStatusProvider _adjustedStatusProvider;
  final AttendanceAdjustmentSubmitter _adjustmentSubmitter;
  final SelectedEmployeeProvider _selectedEmployeeProvider;

  late TimeOfDay _punchInTime = TimeOfDay(hour: 00, minute: 00);
  late TimeOfDay _punchOutTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay? _adjustedPunchInTime;
  TimeOfDay? _adjustedPunchOutTime;
  AttendanceStatus? _adjustedStatus;

  late String status = _attendanceListItem.status.toReadableString();
  late Color statusColor = getStatusColor(_attendanceListItem.status);

  AttendanceAdjustmentPresenter(this._view, this._attendanceListItem)
      : _adjustmentSubmitter = AttendanceAdjustmentSubmitter(),
        _adjustedStatusProvider = AdjustedStatusProvider(),
        _selectedEmployeeProvider = SelectedEmployeeProvider() {
    _initPunchInAndOutTime();
  }

  AttendanceAdjustmentPresenter.initWith(
    this._view,
    this._attendanceListItem,
    this._adjustedStatusProvider,
    this._adjustmentSubmitter,
    this._selectedEmployeeProvider,
  ) {
    _initPunchInAndOutTime();
  }

  void _initPunchInAndOutTime() {
    if (_attendanceListItem.punchInTime != null)
      _punchInTime = TimeOfDay.fromDateTime(_attendanceListItem.punchInTime!);
    if (_attendanceListItem.punchOutTime != null)
      _punchOutTime = TimeOfDay.fromDateTime(_attendanceListItem.punchOutTime!);
    _adjustedPunchInTime = _punchInTime;
    _adjustedPunchOutTime = _punchOutTime;
  }

  //MARK: Function to get adjusted status of attendance_punch_in_out.

  Future<void> adjustPunchInTime(TimeOfDay adjustedPunchInTime) async {
    _punchInTime = adjustedPunchInTime;
    _view.onDidLoadAdjustedStatus();

    await _loadAdjustedStatus(adjustedPunchInTime: adjustedPunchInTime, adjustedPunchOutTime: _adjustedPunchOutTime);

    //if status was adjusted - set the adjusted time

    if (_adjustedStatus != null) {
      _punchInTime = adjustedPunchInTime;
      status = getAdjustedStatus()!;
      statusColor = getStatusColor(_adjustedStatus!);
    }
  }

  Future<void> adjustPunchOutTime(TimeOfDay adjustedPunchOutTime) async {
    _punchOutTime = adjustedPunchOutTime;
    _view.onDidLoadAdjustedStatus();

    await _loadAdjustedStatus(adjustedPunchInTime: _adjustedPunchInTime, adjustedPunchOutTime: adjustedPunchOutTime);

    if (_adjustedStatus != null) {
      _punchOutTime = adjustedPunchOutTime;
      status = getAdjustedStatus()!;
      statusColor = getStatusColor(_adjustedStatus!);
    }
  }

  Future<void> _loadAdjustedStatus({TimeOfDay? adjustedPunchInTime, TimeOfDay? adjustedPunchOutTime}) async {
    if (_adjustedStatusProvider.isLoading) return;

    try {
      _view.showStatusLoader();
      var adjustedStatusForm = AdjustedStatusForm(_attendanceListItem.date, adjustedPunchInTime, adjustedPunchOutTime);
      _adjustedStatus = await _adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm);

      if (adjustedPunchInTime != null) this._adjustedPunchInTime = adjustedPunchInTime;
      if (adjustedPunchOutTime != null) this._adjustedPunchOutTime = adjustedPunchOutTime;

      _view.hideStatusLoader();
      _view.onDidLoadAdjustedStatus();
    } on WPException catch (e) {
      _view.hideStatusLoader();
      _adjustedStatus = null;
      _view.onDidLoadAdjustedStatus();
      _view.onGetAdjustedStatusFailed("Getting adjusted status failed", e.userReadableMessage);
    }
  }

  //MARK: Function to submit adjusted attendance_punch_in_out.

  Future<void> submitAdjustment(String reason) async {
    _view.clearError();

    if (!_isArgumentsValid(reason)) return;

    if (_adjustmentSubmitter.isLoading) return;

    try {
      _view.showLoader();
      var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
      var attendanceAdjustmentForm = AttendanceAdjustmentForm(
        employee,
        _attendanceListItem.date,
        reason,
        _adjustedPunchInTime,
        _adjustedPunchOutTime,
        _adjustedStatus!,
      );
      await _adjustmentSubmitter.submitAdjustment(attendanceAdjustmentForm);
      _view.hideLoader();
      _view.onAdjustAttendanceSuccess('success', 'Adjustment submitted successfully');
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onAdjustAttendanceFailed("Attendance adjustment failed", e.userReadableMessage);
    }
  }

  bool _isArgumentsValid(String reason) {
    var isValid = true;

    if (reason.isEmpty) {
      isValid = false;
      _view.notifyInvalidReason("Invalid reason");
    }
    if (_adjustedStatus == null) {
      isValid = false;
      _view.notifyInvalidAdjustedStatus("Failed", "Attendance not adjusted");
    }
    return isValid;
  }

  //MARK: Getters

  TimeOfDay getPunchInTime() {
    return _punchInTime;
  }

  TimeOfDay getPunchOutTime() {
    return _punchOutTime;
  }

  String? getAdjustedStatus() {
    if (_adjustedStatus != null)
      return _adjustedStatus?.toReadableString();
    else
      return null;
  }

  Color getStatusColor(AttendanceStatus attendanceStatus) {
    switch (attendanceStatus) {
      case AttendanceStatus.Present:
      case AttendanceStatus.NoAction:
      case AttendanceStatus.OnTime:
      case AttendanceStatus.Break:
        return AttendanceAdjustmentColors.presentColor;
      case AttendanceStatus.Late:
      case AttendanceStatus.HalfDay:
      case AttendanceStatus.EarlyLeave:
        return AttendanceAdjustmentColors.lateColor;
      case AttendanceStatus.Absent:
        return AttendanceAdjustmentColors.absentColor;
    }
  }
}
