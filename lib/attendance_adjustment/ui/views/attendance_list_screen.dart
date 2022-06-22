import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/app_bar_divider.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_list_view.dart';
import 'package:wallpost/attendance_adjustment/ui/views/attendance_adjustment_screen.dart';
import 'package:wallpost/attendance_adjustment/ui/views/attendance_list_card.dart';
import 'package:wallpost/attendance_adjustment/ui/views/attendance_list_loader.dart';

class AttendanceListScreen extends StatefulWidget {
  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> implements AttendanceListView {
  late AttendanceListPresenter presenter;

  var _attendanceListNotifier = ItemNotifier<List<AttendanceListItem>>(defaultValue: []);
  var _filtersBarVisibilityNotifier = ItemNotifier<bool>(defaultValue: true);
  var _showErrorNotifier = ItemNotifier<String>(defaultValue: "");
  var _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);

  static const DATA_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const LOADER_VIEW = 3;

  final Color dropDownColor = Color.fromARGB(255, 223, 240, 247);

  @override
  void initState() {
    presenter = AttendanceListPresenter(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => presenter.loadAttendanceList());
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
            } else if (value == DATA_VIEW) {
              return _dataView();
            } else
              return Container();
          },
        ),
      ),
    );
  }

  Widget _dataView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBarDivider(),
        _monthAndYearFilter(),
        Expanded(child: _attendanceListView()),
      ],
    );
  }

  Widget _monthAndYearFilter() {
    return ItemNotifiable <bool>(
        notifier: _filtersBarVisibilityNotifier,
        builder: (context, showFiltersBar) {
      if(showFiltersBar == true) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: dropDownColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: DropdownButton(
                      items: presenter.getMonthsList().map((month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      value: presenter.getSelectedMonth(),
                      onChanged: (month) => setState(() => presenter.selectMonth(month as String)),
                      icon: SvgPicture.asset(
                        'assets/icons/down_arrow_icon.svg',
                        color: AppColors.defaultColorDark,
                        width: 14,
                        height: 14,
                      ),
                      style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColorDark),
                      dropdownColor: dropDownColor,
                      underline: SizedBox(),
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: dropDownColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: DropdownButton(
                      items: presenter.getYearsList().map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(
                            '$year ',
                            style: TextStyle(color: AppColors.defaultColorDark),
                          ),
                        );
                      }).toList(),
                      value: presenter.getSelectedYear(),
                      onChanged: (year) {
                        setState(() {
                          presenter.selectYear(year as int);
                          if (!presenter.getMonthsList().contains(presenter.getSelectedMonth()))
                            presenter.selectMonth(presenter
                                .getMonthsList()
                                .last);
                        });
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/down_arrow_icon.svg',
                        color: AppColors.defaultColorDark,
                        width: 14,
                        height: 14,
                      ),
                      style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColorDark),
                      dropdownColor: dropDownColor,
                      underline: SizedBox(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else return Container();
      }
    );
  }

  Widget _attendanceListView() {
    return ItemNotifiable<List<AttendanceListItem>>(
      notifier: _attendanceListNotifier,
      builder: (context, value) => RefreshIndicator(
        onRefresh: () => presenter.loadAttendanceList(),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: value.length,
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
      onPressed: () => goToAdjustmentScreen(index, attendanceList[index]),
    );
  }

  Widget _errorAndRetryView() {
    return ItemNotifiable<String>(
      notifier: _showErrorNotifier,
      builder: (context, message) {
        return Column(
          children: [
            AppBarDivider(),
            _monthAndYearFilter(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyles.titleTextStyle,
                    ),
                    onPressed: () => presenter.refresh(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void hideLoader() {}

  @override
  void showAttendanceList(List<AttendanceListItem> attendanceList) {
    _viewTypeNotifier.notify(DATA_VIEW);
    _attendanceListNotifier.notify(attendanceList);
  }

  @override
  void showNoListMessage(String message) {
    _viewTypeNotifier.notify(ERROR_VIEW);
    _showErrorNotifier.notify(message);
  }

  @override
  void showErrorMessage(String errorMessage) {
    _filtersBarVisibilityNotifier.notify(false);
    _viewTypeNotifier.notify(ERROR_VIEW);
    _showErrorNotifier.notify(errorMessage);
  }

  @override
  void goToAdjustmentScreen(int index, AttendanceListItem attendanceList) {
    ScreenPresenter.present(
        AttendanceAdjustmentScreen(
          attendanceListItem: attendanceList,
        ),
        context);
  }
}
