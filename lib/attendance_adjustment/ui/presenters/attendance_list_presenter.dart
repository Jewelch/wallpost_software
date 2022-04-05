import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_list_view.dart';

import '../../../_shared/constants/app_colors.dart';
import '../../../attendance__core/entities/attendance_status.dart';

class AttendanceListPresenter {
  final AttendanceListView _view;
  final AttendanceListProvider _attendanceListProvider;
  List<AttendanceListItem> _attendanceList = [];

  final Color presentColor = Color.fromRGBO(43, 186, 104, 1.0);
  final Color absentColor = Colors.red;
  final Color lateColor = Colors.purple;
  final Color labelColor = Colors.yellow;

  late int _selectedYear = DateTime
      .now()
      .year;
  late String _selectedMonth = AppYears
      .shortenedMonthNames(_selectedYear)
      .last;

  AttendanceListPresenter(this._view)
      : _attendanceListProvider = AttendanceListProvider(),
        _selectedYear = AppYears
            .years()
            .first;

  AttendanceListPresenter.initWith(this._view,
      this._attendanceListProvider,) : _selectedYear = AppYears
      .years()
      .first;

  //MARK: Function to load the attendance_punch_in_out list

  Future<void> loadAttendanceList() async {
    if (_attendanceListProvider.isLoading) return;

    _attendanceList.clear();
    _view.showLoader();
    try {
      var monthNumber = AppYears.shortenedMonthNames(_selectedYear).indexOf((_selectedMonth)) + 1;
      var attendanceList = await _attendanceListProvider.get(monthNumber, _selectedYear);
      _attendanceList.addAll(attendanceList);

      if (_attendanceList.isNotEmpty) {
        _view.showAttendanceList(_attendanceList);
      } else {
        _view.showNoListMessage(
            "There is no attendance_punch_in_out for $_selectedMonth $_selectedYear.\n\nTap here to reload.");
      }
      _view.hideLoader();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  //MARK: Function to refresh the attendance_punch_in_out list

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
    return AppYears.shortenedMonthNames(_selectedYear);
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
      case AttendanceStatus.OnTime:
      case AttendanceStatus.Break:
        return presentColor;
      case AttendanceStatus.Late:
      case AttendanceStatus.HalfDay:
      case AttendanceStatus.EarlyLeave:
        return lateColor;
      case AttendanceStatus.Absent:
        return absentColor;
    }
  }

  Color getPunchInLabelColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.Late:
        return lateColor;
      default:
        return Colors.black;
    }
  }

  Color punchOutLabelColorForItem(AttendanceListItem attendanceItem) {
    switch (attendanceItem.status) {
      case AttendanceStatus.HalfDay:
        return lateColor;
      case AttendanceStatus.Absent:
        return absentColor;
      default:
        return Colors.black;
    }
  }
}
