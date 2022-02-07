import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class _AttendanceListScreenState extends State<AttendanceListScreen>
    implements AttendanceListView {
  late AttendanceListPresenter presenter;

  var _attendanceListNotifier = ItemNotifier<List<AttendanceListItem>?>();
  var _showErrorNotifier = ItemNotifier<bool>();
  var _viewSelectorNotifier = ItemNotifier<int>();
  var _scrollController = ScrollController();

  String _errorMessage = "";
  String _noAttendanceListMessage = "";

  late int selectedYear = DateTime.now().year;
  late int selectedMonth = DateTime.now().month;
  String monthValue = DateFormat("MMM").format(DateTime.now());

  static const ATTENDANCE_LIST_VIEW = 1;
  static const NO_ATTENDANCE_LIST_VIEW = 2;
  static const ERROR_VIEW = 3;
  late Loader loader;

  @override
  void initState() {
    loader = Loader(context);
    presenter = AttendanceListPresenter(this);
    super.initState();
    Future.delayed(Duration.zero, () {
      this.presenter.loadAttendanceList(
          presenter.getCurrentMonth(), presenter.getCurrentYear());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Adjust Attendance',
        leadingButtons: [
          CircularBackButton(
              color: Colors.white,
              iconColor: AppColors.defaultColor,
              onPressed: () => Navigator.pop(context)),
        ],
        showDivider: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _monthAndYearFilter(),
          ItemNotifiable<int>(
              notifier: _viewSelectorNotifier,
              builder: (context, value) {
                if (value == ATTENDANCE_LIST_VIEW) {
                  return Expanded(child: _getAttendanceList());
                } else if (value == NO_ATTENDANCE_LIST_VIEW) {
                  return Expanded(child: _noAttendanceListMessageView());
                } else
                  return Expanded(child: _buildErrorAndRetryView());
              }),
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
          Text('Month/Year',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  value: monthValue,
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  onChanged: (newValue) {
                    setState(() {
                      monthValue = newValue.toString();
                      DateTime date = DateFormat.MMM().parse(monthValue);
                      selectedMonth = date.month;
                      showFilteredAttendanceList();
                    });
                  },
                  items: presenter.getMonthsList(selectedYear).map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 15,
                ),
                DropdownButton(
                  value: selectedYear,
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  onChanged: (newValue) {
                    setState(() {
                      selectedYear = newValue as int;
                      showFilteredAttendanceList();
                    });
                  },
                  items: presenter.getYearsList().map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem.toString()),
                    );
                  }).toList(),
                ),
              ]),
        ],
      ),
    );
  }

  Widget _getAttendanceList() {
    return ItemNotifiable<List<AttendanceListItem>>(
        notifier: _attendanceListNotifier,
        builder: (context, value) => RefreshIndicator(
              onRefresh: () =>
                  presenter.loadAttendanceList(selectedMonth, selectedYear),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                itemCount: value!.length,
                itemBuilder: (context, index) {
                  return _getAttendanceCard(index, value);
                },
              ),
            ));
  }

  Widget _getAttendanceCard(
      int index, List<AttendanceListItem> attendanceList) {
    return AttendanceListCard(
      attendanceListItem: attendanceList[index],
      onPressed: () => goToAdjustmentScreen(),
    );
  }

  Widget _noAttendanceListMessageView() {
    return GestureDetector(
      onTap: () => presenter.refresh(),
      child: Container(
        child: Center(
            child: Text(
          _noAttendanceListMessage,
          textAlign: TextAlign.center,
          style: TextStyles.failureMessageTextStyle,
        )),
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return ItemNotifiable<bool>(
        notifier: _showErrorNotifier,
        builder: (context, value) {
          if (value == true) {
            return Container(
              height: 150,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyles.failureMessageTextStyle,
                      ),
                      onPressed: () => presenter.refresh(),
                    ),
                  ],
                ),
              ),
            );
          } else
            return Container();
        });
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
    _attendanceListNotifier.notify(attendanceList);
    _viewSelectorNotifier.notify(ATTENDANCE_LIST_VIEW);
  }

  @override
  void showNoListMessage(String message) {
    _noAttendanceListMessage = message;
    _viewSelectorNotifier.notify(NO_ATTENDANCE_LIST_VIEW);
  }

  @override
  void showErrorMessage(String errorMessage) {
    _errorMessage = errorMessage;
    _showErrorNotifier.notify(true);
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void showFilteredAttendanceList() {
    presenter.loadAttendanceList(selectedMonth, selectedYear);
  }

  @override
  void goToAdjustmentScreen() {
    // ScreenPresenter.presentAndRemoveAllPreviousScreens(
    //     AttendanceAdjustmentScreen(), context);
  }
}
