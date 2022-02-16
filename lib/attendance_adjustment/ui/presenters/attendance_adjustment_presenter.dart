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
import 'package:wallpost/company_list/services/selected_employee_provider.dart';

class AttendanceAdjustmentPresenter {
  final AttendanceAdjustmentView _view;
  final AdjustedStatusProvider _adjustedStatusProvider;
  final AttendanceAdjustmentSubmitter _adjustmentSubmitter;
  final SelectedEmployeeProvider _selectedEmployeeProvider;

  late TimeOfDay punchInTime = TimeOfDay(hour: 00, minute: 00);
  late TimeOfDay punchOutTime = TimeOfDay(hour: 00, minute: 00);
  late TimeOfDay adjustedTime = TimeOfDay(hour: 00, minute: 00);
  late DateTime? adjustedPunchInTime = null;
  late DateTime? adjustedPunchOutTime = null;

  var adjustedStatus;
  String? punchInAdjusted;
  String? punchOutAdjusted;
  Color adjustedPunchInColor = Colors.white;
  Color adjustedPunchOutColor = Colors.white;

  AttendanceAdjustmentPresenter(this._view)
      : _adjustmentSubmitter = AttendanceAdjustmentSubmitter(),
        _adjustedStatusProvider = AdjustedStatusProvider(),
        _selectedEmployeeProvider = SelectedEmployeeProvider();

  AttendanceAdjustmentPresenter.initWith(this._view, this._adjustmentSubmitter,
      this._adjustedStatusProvider, this._selectedEmployeeProvider);

  Future<dynamic> loadAdjustedStatus(DateTime date) async {
    if (_adjustedStatusProvider.isLoading) return;
    try {
      _view.showLoader();
      var adjustedStatusForm =
          AdjustedStatusForm(date, adjustedPunchInTime, adjustedPunchOutTime);
      adjustedStatus =
          await _adjustedStatusProvider.getAdjustedStatus(adjustedStatusForm);
      _view.hideLoader();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onGetAdjustedStatusFailed(
          "Getting adjusted status failed", e.userReadableMessage);
    }
    return adjustedStatus;
  }

  Future<void> submitAdjustment(DateTime date,String reason) async {
    _view.clearError();

    if (!_isArgumentsValid(reason)) return;

    if (_adjustmentSubmitter.isLoading) return;

    try {
      _view.showLoader();
      var employee =
          _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
      var attendanceAdjustmentForm = AttendanceAdjustmentForm(employee, date,
          reason, adjustedPunchInTime, adjustedPunchOutTime, adjustedStatus);
      await _adjustmentSubmitter.submitAdjustment(attendanceAdjustmentForm);
      _view.hideLoader();
      _view.onAdjustAttendanceSuccess(
          'success', 'Adjustment submitted successfully');
    } on WPException catch (e) {
      _view.hideLoader();
      _view.onAdjustAttendanceFailed(
          "Attendance adjustment failed", e.userReadableMessage);
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

  String getPeriod(TimeOfDay time) {
    if (time.period == DayPeriod.am) {
      return 'AM';
    } else
      return 'PM';
  }

  DateTime getAdjustedPunchIn() {
    return adjustedPunchInTime = DateFormat("hh:mm").parse(
        adjustedTime.hour.toString() + ":" + adjustedTime.minute.toString());
  }

  DateTime getAdjustedPunchOut() {
    return adjustedPunchOutTime = DateFormat("hh:mm").parse(
        adjustedTime.hour.toString() + ":" + adjustedTime.minute.toString());
  }

  Color punchInOutLabelColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.Late:
        return AppColors.lateColor;
      default:
        return AppColors.labelColor;
    }
  }

  void changePropertiesOfPunchInContainer(){
    if(punchInTime != adjustedTime){
      punchInAdjusted = ' - Adjusted';
      adjustedPunchInColor = AppColors.lightBlueColor;
    }
    punchInTime = adjustedTime;
   }

  void changePropertiesOfPunchOutContainer(){
    if(punchOutTime != adjustedTime){
      punchOutAdjusted = ' - Adjusted';
      adjustedPunchOutColor = AppColors.lightBlueColor;
    }
    punchOutTime = adjustedTime;
    }
}
