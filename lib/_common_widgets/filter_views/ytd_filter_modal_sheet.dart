import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_shared/constants/app_years.dart';

import '../../_shared/constants/app_colors.dart';
import '../text_styles/text_styles.dart';
import 'custom_filter_chip.dart';

/// month = 0 in case of YTD
/// month = 1 to 12 for Jan to Feb
/// year belongs to AppYears().years()

class YTDFilterModalSheet extends StatefulWidget {
  final _years = AppYears().years().reversed.toList();
  late final int _initialMonth;
  late final int _initialYear;
  final Function(int month, int year) onDidSelectFilter;
  final ModalSheetController modalSheetController;

  YTDFilterModalSheet._({
    required initialMonth,
    required initialYear,
    required this.onDidSelectFilter,
    required this.modalSheetController,
  }) {
    this._initialMonth = _isMonthValidForYear(initialMonth, initialYear) ? initialMonth : 0;
    this._initialYear = _years.contains(initialYear) ? initialYear : _years.last;
  }

  static Future<dynamic> show(
    BuildContext context, {
    bool allowMultiple = false,
    required initialMonth,
    required initialYear,
    required onDidSelectFilter,
    ModalSheetController? modalSheetController,
  }) {
    var controller = modalSheetController ?? ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      controller: controller,
      content: YTDFilterModalSheet._(
        initialMonth: initialMonth,
        initialYear: initialYear,
        onDidSelectFilter: onDidSelectFilter,
        modalSheetController: controller,
      ),
    );
  }

  @override
  State<YTDFilterModalSheet> createState() => _YTDFilterModalSheetState(_initialMonth, _initialYear);

  bool _isMonthValidForYear(int month, int year) {
    if (month <= AppYears().currentAndPastMonthsOfYear(year).length) return true;

    return false;
  }
}

class _YTDFilterModalSheetState extends State<YTDFilterModalSheet> {
  int _selectedMonth;
  int _selectedYear;

  _YTDFilterModalSheetState(initialMonth, int initialYear)
      : _selectedMonth = initialMonth,
        _selectedYear = initialYear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => widget.modalSheetController.close(),
                  child: Text(
                    "Cancel",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  "Filters",
                  style: TextStyles.screenTitleTextStyle.copyWith(
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () => _resetFilters(),
                  child: Text(
                    "Reset",
                    style: TextStyles.screenTitleTextStyle.copyWith(color: AppColors.red, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Year",
            style:
                TextStyles.screenTitleTextStyle.copyWith(color: AppColors.textColorBlack, fontWeight: FontWeight.w500),
          ),
          // getYearsList(),
          SizedBox(height: 200, child: getYearsList()),
          SizedBox(height: 16),
          Text(
            "Months",
            style:
                TextStyles.screenTitleTextStyle.copyWith(color: AppColors.textColorBlack, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 200, child: getMonthsList()),
          SizedBox(height: 16),
          SizedBox(height: 40),
          GestureDetector(
            onTap: () => _applyFilters(),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.defaultColor,
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Center(
                child: Text(
                  'Apply Changes',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget getYearsList() {
    return GridView.count(
      childAspectRatio: (1 / .4),
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(vertical: 12),
      children: List.generate(_getYears().length, (index) {
        return CustomFilterChip(
          backgroundColor: _isYearSelected(_getYears()[index]) ? AppColors.defaultColor : Colors.white,
          borderColor: Colors.transparent,
          onPressed: () => _selectYearAtIndex(index),
          title: Text(
            "${_getYears()[index]}",
            style: TextStyle(
              color: _isYearSelected(_getYears()[index]) ? Colors.white : AppColors.defaultColorDarkContrastColor,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  Widget getMonthsList() {
    return GridView.count(
      childAspectRatio: (1 / .4),
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12),
      children: List.generate(_getMonthNamesForSelectedYear().length, (index) {
        return CustomFilterChip(
          backgroundColor:
              _isMonthSelected(_getMonthNamesForSelectedYear()[index]) ? AppColors.defaultColor : Colors.white,
          borderColor: Colors.transparent,
          onPressed: () => _selectMonthAtIndex(index),
          title: Text(
            "${_getMonthNamesForSelectedYear()[index]}",
            style: TextStyle(
              color: _isMonthSelected(_getMonthNamesForSelectedYear()[index])
                  ? Colors.white
                  : AppColors.defaultColorDarkContrastColor,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  //MARK: Functions to get months and years

  List<String> _getMonthNamesForSelectedYear() {
    return AppYears().currentAndPastShortenedMonthsOfYear(_selectedYear);
  }

  List<int> _getYears() {
    return widget._years;
  }

  //MARK: Functions to select month and year

  void _selectYearAtIndex(int index) {
    setState(() {
      _selectedYear = widget._years[index];
      if (!widget._isMonthValidForYear(_selectedMonth, _selectedYear)) _selectedMonth = 0;
    });
  }

  void _selectMonthAtIndex(int index) {
    setState(() {
      if (_selectedMonth == index + 1) {
        _selectedMonth = 0;
      } else {
        _selectedMonth = index + 1;
      }
    });
  }

  //MARK: Function to reset the filters

  void _resetFilters() {
    widget.onDidSelectFilter(0, widget._years.first);
    widget.modalSheetController.close();
  }

  //MARK: Function to apply filters

  void _applyFilters() {
    widget.onDidSelectFilter(_selectedMonth, _selectedYear);
    widget.modalSheetController.close();
  }

  //MARK: Functions to check if year or month is selected

  bool _isYearSelected(int year) {
    return year == _selectedYear;
  }

  bool _isMonthSelected(String monthName) {
    return _getMonthNamesForSelectedYear().indexOf(monthName) + 1 == _selectedMonth;
  }
}
