import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/ui/contracts/attendance_list_view.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/views/attendance_list_card.dart';

class AttendanceListScreen extends StatefulWidget {
  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> implements AttendanceListView {
  late AttendanceListPresenter presenter;

  var _attendanceListNotifier = ItemNotifier<List<AttendanceListItem>?>();
  var _showErrorNotifier = ItemNotifier<String>();
  var _viewTypeNotifier = ItemNotifier<int>();

  static const ATTENDANCE_LIST_VIEW = 1;
  static const ERROR_VIEW = 2;
  late Loader loader;

  @override
  void initState() {
    loader = Loader(context);
    presenter = AttendanceListPresenter(this);
    WidgetsBinding.instance?.addPostFrameCallback((_) => presenter.loadAttendanceList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Adjust Attendance',
        showDivider: true,
        leadingButtons: [
          CircularBackButton(
            color: Colors.white,
            iconColor: AppColors.defaultColor,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _monthAndYearFilter(),
          ItemNotifiable<int>(
            notifier: _viewTypeNotifier,
            builder: (context, value) {
              if (value == ATTENDANCE_LIST_VIEW) {
                return Expanded(child: _attendanceListView());
              } else
                return Expanded(child: _errorAndRetryView());
            },
          ),
        ],
      ),
    );
  }

  Widget _monthAndYearFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Month/Year', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                items: presenter.getMonthsList().map((month) {
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                value: presenter.getSelectedMonth(),
                icon: Icon(Icons.arrow_drop_down_sharp),
                onChanged: (month) => presenter.selectMonth(month as String),
              ),
              SizedBox(width: 15),
              DropdownButton(
                items: presenter.getYearsList().map((year) {
                  return DropdownMenuItem(
                    value: year,
                    child: Text('$year'),
                  );
                }).toList(),
                value: presenter.getSelectedYear(),
                icon: Icon(Icons.arrow_drop_down_sharp),
                onChanged: (year) => presenter.selectYear(year as int),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceListView() {
    return ItemNotifiable<List<AttendanceListItem>>(
      notifier: _attendanceListNotifier,
      builder: (context, value) => RefreshIndicator(
        onRefresh: () => presenter.loadAttendanceList(),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: value!.length,
          itemBuilder: (context, index) {
            return _attendanceCardView(index, value);
          },
        ),
      ),
    );
  }

  Widget _attendanceCardView(int index, List<AttendanceListItem> attendanceList) {
    return AttendanceListCard(
      presenter: presenter,
      attendanceListItem: attendanceList[index],
      onPressed: () => goToAdjustmentScreen(),
    );
  }

  Widget _errorAndRetryView() {
    return ItemNotifiable<String>(
      notifier: _showErrorNotifier,
      builder: (context, message) {
        return Container(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyles.failureMessageTextStyle,
                  ),
                  onPressed: () => presenter.refresh(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void showLoader() {
    loader.showLoadingIndicator("Loading");
  }

  @override
  void hideLoader() {
    loader.hideOpenDialog();
  }

  @override
  void showAttendanceList(List<AttendanceListItem> attendanceList) {
    _viewTypeNotifier.notify(ATTENDANCE_LIST_VIEW);
    _attendanceListNotifier.notify(attendanceList);
  }

  @override
  void showNoListMessage(String message) {
    _viewTypeNotifier.notify(ERROR_VIEW);
    _showErrorNotifier.notify(message);
  }

  @override
  void showErrorMessage(String errorMessage) {
    _viewTypeNotifier.notify(ERROR_VIEW);
    _showErrorNotifier.notify(errorMessage);
  }

  @override
  void goToAdjustmentScreen() {
    // ScreenPresenter.presentAndRemoveAllPreviousScreens(
    //     AttendanceAdjustmentScreen(), context);
  }
}
