import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/contracts/attendance_list_view.dart';

import '../../../_shared/constants/app_colors.dart';
import '../../entities/attendance_status.dart';

class AttendanceListPresenter {
  final AttendanceListView _view;
  final AttendanceListProvider _attendanceListProvider;
  List<AttendanceListItem> _attendanceList = [];

  late int _selectedYear;
  late String _selectedMonth;

  AttendanceListPresenter(this._view)
      : _attendanceListProvider = AttendanceListProvider(),
        _selectedYear = AppYears.years().first,
        _selectedMonth = AppYears.shortenedMonthNames()[DateTime.now().month - 1];

  AttendanceListPresenter.initWith(
    this._view,
    this._attendanceListProvider,
  )   : _selectedYear = AppYears.years().first,
        _selectedMonth = AppYears.shortenedMonthNames()[DateTime.now().month - 1];

  //MARK: Function to load the attendance list

  Future<void> loadAttendanceList() async {
    if (_attendanceListProvider.isLoading) return;

    _attendanceList.clear();
    _view.showLoader();
    try {
      var monthNumber = AppYears.shortenedMonthNames().indexOf((_selectedMonth)) + 1;
      var attendanceList =
          await _attendanceListProvider.get(monthNumber, _selectedYear);
      _attendanceList.addAll(attendanceList);

      if (_attendanceList.isNotEmpty) {
        _view.showAttendanceList(_attendanceList);
      } else {
        _view.showNoListMessage(
            "There is no attendance for $_selectedMonth $_selectedYear.\n\nTap here to reload.");
      }
      _view.hideLoader();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  //MARK: Function to refresh the attendance list//

  refresh() {
    _attendanceListProvider.reset();
    loadAttendanceList();
  }

  //MARK: Functions to select year and month filters

  void selectYear(int year) {
    _selectedYear = year;
    refresh();
  }

  void selectMonth(String month) {
    _selectedMonth = month;
    refresh();
  }

  //MARK: Getters

  List<int> getYearsList() {
    return AppYears.years();
  }

  List<String> getMonthsList() {
    return AppYears.shortenedMonthNames();
  }

  String getSelectedMonth() {
    return _selectedMonth;
  }

  int getSelectedYear() {
    return _selectedYear;
  }

  Color getStatusColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.Present:
      case AttendanceStatus.NoAction:
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

  Color getPunchInLabelColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.Late:
        return AppColors.lateColor;
      default:
        return Colors.black;
    }
  }

  Color punchOutLabelColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.HalfDay:
        return AppColors.lateColor;
      case AttendanceStatus.Absent:
        return AppColors.absentColor;
      default:
        return Colors.black;
    }
  }
}
