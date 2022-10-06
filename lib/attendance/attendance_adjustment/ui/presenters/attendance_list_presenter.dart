import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance/attendance_adjustment/ui/view_contracts/attendance_list_view.dart';

import '../../../attendance__core/entities/attendance_status.dart';
import '../../../attendance__core/utils/attendance_status_color.dart';

class AttendanceListPresenter {
  final AttendanceListView _view;
  final AttendanceListProvider _attendanceListProvider;
  final AppYears _yearsAndMonthsProvider;
  List<AttendanceListItem> _attendanceList = [];

  late int _selectedYear;
  late String _selectedMonth;

  AttendanceListPresenter(this._view)
      : _attendanceListProvider = AttendanceListProvider(),
        _yearsAndMonthsProvider = AppYears() {
    _initYearAndMonth();
  }

  AttendanceListPresenter.initWith(this._view, this._attendanceListProvider, this._yearsAndMonthsProvider) {
    _initYearAndMonth();
  }

  void _initYearAndMonth() {
    _selectedYear = _yearsAndMonthsProvider.years().last;
    _selectedMonth = _yearsAndMonthsProvider.currentAndPastMonthsOfYear(_selectedYear).last;
  }

  //MARK: Function to load the attendance_punch_in_out list

  Future<void> loadAttendanceList() async {
    if (_attendanceListProvider.isLoading) return;

    _view.showLoader();
    try {
      var monthNumber = getMonthsListOfSelectedYear().indexOf((_selectedMonth)) + 1;
      _attendanceList = await _attendanceListProvider.get(monthNumber, _selectedYear);

      if (_attendanceList.isNotEmpty) {
        _view.onDidLoadAttendanceList();
      } else {
        _view.showNoAttendanceMessage(
            "There is no attendance for $_selectedMonth $_selectedYear.\n\nTap here to reload.");
      }
    } on WPException catch (e) {
      _view.onDidFailToLoadAttendanceList("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Functions to get list details

  int getNumberOfListItems() {
    return _attendanceList.length;
  }

  AttendanceListItem getItemAtIndex(int index) {
    return _attendanceList[index];
  }

  //MARK: Functions to get list item details

  String getListItemTitle(AttendanceListItem attendanceListItem) {
    if (attendanceListItem.status == AttendanceStatus.Absent) {
      return _getDayName(attendanceListItem.date);
    } else {
      return '${_getDayName(attendanceListItem.date)}, ${_convertTimeToString(attendanceListItem.punchInTime)} to ${_convertTimeToString(attendanceListItem.punchOutTime)}';
    }
  }

  String getMonth(AttendanceListItem attendanceListItem) {
    return DateFormat('MMM').format(attendanceListItem.date);
  }

  String getDay(AttendanceListItem attendanceListItem) {
    return DateFormat('dd').format(attendanceListItem.date);
  }

  String _getDayName(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime);
  }

  String _convertTimeToString(DateTime? time) {
    if (time == null) return '';
    return DateFormat('hh:mm a').format(time);
  }

  String getStatus(AttendanceListItem attendanceListItem) {
    return attendanceListItem.status.toReadableString();
  }

  Color getStatusColorForItem(AttendanceListItem attendanceItem) {
    return AttendanceStatusColor.getStatusColor(attendanceItem.status);
  }

  String getApprovalInfo(AttendanceListItem attendanceListItem) {
    if (attendanceListItem.isApprovalPending() && attendanceListItem.approverName != null) {
      return "Pending Approval with ${attendanceListItem.approverName}";
    }

    return "";
  }

  //MARK: Functions to get and select filters

  List<String> getYearsList() {
    return _yearsAndMonthsProvider.years().map((e) => "$e").toList();
  }

  List<String> getMonthsListOfSelectedYear() {
    return _yearsAndMonthsProvider.currentAndPastMonthsOfYear(_selectedYear);
  }

  Future<void> selectYear(int year) async {
    _selectedYear = year;
    if (!getMonthsListOfSelectedYear().contains(_selectedMonth)) _selectedMonth = getMonthsListOfSelectedYear().last;
    await loadAttendanceList();
  }

  Future<void> selectMonth(String month) async {
    _selectedMonth = month;
    await loadAttendanceList();
  }

  String getSelectedMonth() {
    return _selectedMonth;
  }

  String getSelectedYear() {
    return "$_selectedYear";
  }
}
