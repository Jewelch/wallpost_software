import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/adjusted_status_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/services/adjusted_status_provider.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class AttendanceAdjustmentPresenter {
  final AttendanceAdjustmentView _view;
  final AdjustedStatusProvider _adjustedStatusProvider;
  final AttendanceAdjustmentSubmitter _adjustmentSubmitter;
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final AttendanceListItem _attendanceListItem;

  late TimeOfDay punchInTime = TimeOfDay(hour: 00, minute: 00);
  late TimeOfDay punchOutTime = TimeOfDay(hour: 00, minute: 00);
  late TimeOfDay adjustedTime = TimeOfDay(hour: 00, minute: 00);
  late DateTime? adjustedPunchInTime = null;
  late DateTime? adjustedPunchOutTime = null;
  late DateTime date = _attendanceListItem.date;
  AttendanceStatus? adjustedStatus = null;

  String? punchInAdjusted, punchOutAdjusted;
  Color adjustedPunchInColor = Colors.white;
  Color adjustedPunchOutColor = Colors.white;
  late String status = _attendanceListItem.status.toReadableString();
  late Color statusColor = getStatusColor(_attendanceListItem.status);

  AttendanceAdjustmentPresenter(this._view, this._attendanceListItem)
      : _adjustmentSubmitter = AttendanceAdjustmentSubmitter(),
        _adjustedStatusProvider = AdjustedStatusProvider(),
        _selectedEmployeeProvider = SelectedEmployeeProvider();

  AttendanceAdjustmentPresenter.initWith(
      this._view,
      this._attendanceListItem,
      this._adjustmentSubmitter,
      this._adjustedStatusProvider,
      this._selectedEmployeeProvider);


  //MARK: Function to get adjusted status of attendance.

  Future<dynamic> loadAdjustedStatus() async {
    if (_adjustedStatusProvider.isLoading) return;

    try {
      _view.showLoader();
      var adjustedStatusForm = AdjustedStatusForm(date, adjustedPunchInTime, adjustedPunchOutTime);
      adjustedStatus = await _adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm);
      _view.hideLoader();
    } on WPException catch (e) {
      _view.hideLoader();
      adjustedStatus = null;
      _view.onGetAdjustedStatusFailed("Getting adjusted status failed", e.userReadableMessage);
    }
    return adjustedStatus;
  }

  //MARK: Function to submit adjusted attendance.

  Future<void> submitAdjustment(String reason) async {
    _view.clearError();

    if (!_isArgumentsValid(reason)) return;

    if (_adjustmentSubmitter.isLoading) return;

    try {
      _view.showLoader();
      var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
      var attendanceAdjustmentForm = AttendanceAdjustmentForm(employee, date, reason, adjustedPunchInTime, adjustedPunchOutTime, adjustedStatus!);
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
    if (adjustedStatus == null) {
      isValid = false;
      _view.notifyInvalidAdjustedStatus("Failed", "Attendance not adjusted");
    }
    return isValid;
  }


  //MARK: Functions to set color and text for adjusted attendance.

  void changePropertiesOfPunchInContainer() {
    if (getAdjustedStatus() != null) {
      updateStatus();
      setColorForPunchIn();
    } else {
      setDefaultPropertiesForPunchIn();
    }
  }

  void updateStatus() {
    status = getAdjustedStatus()!;
    statusColor = getStatusColor(adjustedStatus!);
  }

  void setColorForPunchIn() {
    if (adjustedTime != TimeOfDay(hour: 0, minute: 0)) {
      punchInAdjusted = ' - Adjusted';
      adjustedPunchInColor = AppColors.lightBlueColor;
    }
    punchInTime = adjustedTime;
  }

  void setDefaultPropertiesForPunchIn() {
    punchInAdjusted = '';
    adjustedPunchInColor = Colors.white;
    punchInTime = TimeOfDay(hour: 0, minute: 0);
  }

  void changePropertiesOfPunchOutContainer() {
    if (getAdjustedStatus() != null) {
      updateStatus();
      setColorForPunchOut();
    } else {
      setDefaultPropertiesForPunchOut();
    }
  }

  void setColorForPunchOut() {
    if (adjustedTime != TimeOfDay(hour: 0, minute: 0)) {
      punchOutAdjusted = ' - Adjusted';
      adjustedPunchOutColor = AppColors.lightBlueColor;
    }
    punchOutTime = adjustedTime;
  }

  void setDefaultPropertiesForPunchOut() {
    punchOutAdjusted = '';
    adjustedPunchOutColor = Colors.white;
    punchOutTime = TimeOfDay(hour: 00, minute: 00);
  }

  //MARK: Getters

  String getPeriod(TimeOfDay time) {
    if (time.period == DayPeriod.am) {
      return 'AM';
    } else
      return 'PM';
  }

  String? getAdjustedStatus() {
    if (adjustedStatus != null)
      return adjustedStatus?.toReadableString();
    else
      return null;
  }

  DateTime getAdjustedPunchInAsDateTime() {
    return adjustedPunchInTime = DateFormat("hh:mm").parse(adjustedTime.hour.toString() + ":" + adjustedTime.minute.toString());
  }

  DateTime getAdjustedPunchOutAsDateTime() {
    return adjustedPunchOutTime = DateFormat("hh:mm").parse(adjustedTime.hour.toString() + ":" + adjustedTime.minute.toString());
  }

  Color getStatusColor(AttendanceStatus attendanceStatus) {
    switch (attendanceStatus) {
      case AttendanceStatus.Present:
      case AttendanceStatus.NoAction:
      case AttendanceStatus.OnTime:
      case AttendanceStatus.Break:
        return AppColors.presentColor;
      case AttendanceStatus.Late:
      case AttendanceStatus.HalfDay:
      case AttendanceStatus.EarlyLeave:
        return AppColors.lateColor;
      case AttendanceStatus.Absent:
        return AppColors.absentColor;
    }
  }

  Color getLabelColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.Late:
        return AppColors.lateColor;
      default:
        return AppColors.labelColor;
    }
  }
}
