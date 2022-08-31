import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/attendance/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment/ui/view_contracts/attendance_list_view.dart';
import 'package:wallpost/attendance/attendance_adjustment/ui/views/attendance_adjustment_screen.dart';
import 'package:wallpost/attendance/attendance_adjustment/ui/views/attendance_list_loader.dart';

import '../../../../_common_widgets/filter_views/dropdown_filter.dart';
import 'attendance_list_item_card.dart';

class AttendanceListScreen extends StatefulWidget {
  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> implements AttendanceListView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const NO_ITEMS_VIEW = 3;
  static const DATA_VIEW = 4;
  var _viewTypeNotifier = ItemNotifier<int>(defaultValue: DATA_VIEW);
  late AttendanceListPresenter presenter;

  var _errorMessage = "";

  @override
  void initState() {
    presenter = AttendanceListPresenter(this);
    presenter.loadAttendanceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Attendance',
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable<int>(
          notifier: _viewTypeNotifier,
          builder: (context, value) {
            if (value == LOADER_VIEW) {
              return AttendanceListLoader();
            } else if (value == ERROR_VIEW) {
              return _errorAndRetryView();
            } else if (value == NO_ITEMS_VIEW) {
              return _noItemsView();
            } else if (value == DATA_VIEW) {
              return _dataView();
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _errorAndRetryView() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle,
                ),
                onPressed: () => presenter.loadAttendanceList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _noItemsView() {
    return Column(
      children: [
        SizedBox(height: 20),
        _monthAndYearFilter(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                child: Text(_errorMessage, textAlign: TextAlign.center, style: TextStyles.titleTextStyle),
                onPressed: () => presenter.loadAttendanceList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20),
        _monthAndYearFilter(),
        SizedBox(height: 10),
        Expanded(child: _attendanceListView()),
      ],
    );
  }

  Widget _attendanceListView() {
    return RefreshIndicator(
      onRefresh: () => presenter.loadAttendanceList(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: presenter.getNumberOfListItems(),
        itemBuilder: (context, index) => AttendanceListCard(
          presenter: presenter,
          attendanceListItem: presenter.getItemAtIndex(index),
          onPressed: () => goToAdjustmentScreen(presenter.getItemAtIndex(index)),
        ),
      ),
    );
  }

  Widget _monthAndYearFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: DropdownFilter(
              items: presenter.getMonthsListOfSelectedYear(),
              selectedValue: presenter.getSelectedMonth(),
              onDidSelectItemWithValue: (month) => presenter.selectMonth(month),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: DropdownFilter(
              items: presenter.getYearsList(),
              selectedValue: presenter.getSelectedYear(),
              onDidSelectItemWithValue: (year) => presenter.selectYear(int.parse(year)),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void onDidFailToLoadAttendanceList(String errorMessage) {
    _errorMessage = errorMessage;
    _viewTypeNotifier.notify(ERROR_VIEW);
  }

  @override
  void showNoAttendanceMessage(String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(NO_ITEMS_VIEW);
  }

  @override
  void onDidLoadAttendanceList() {
    _viewTypeNotifier.notify(DATA_VIEW);
  }

  @override
  void goToAdjustmentScreen(AttendanceListItem attendanceListItem) {
    ScreenPresenter.present(AttendanceAdjustmentScreen(attendanceListItem: attendanceListItem), context)
        .then((didUpdateAttendance) {
      if (didUpdateAttendance == true) presenter.loadAttendanceList();
    });
  }
}
