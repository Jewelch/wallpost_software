import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/dropdown_filter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_years.dart';

import '../../_shared/constants/app_colors.dart';

/// month = 0 in case of YTD
/// month = 1 to 12 for Jan to Feb
/// year belongs to AppYears().years()

class YtdFilter extends StatefulWidget {
  final _years = AppYears().years();
  late final int _initialMonth;
  late final int _initialYear;
  final Function(int selectedMonth, int selectedYear) onDidChangeFilter;

  YtdFilter(
      {required initialMonth,
      required initialYear,
      required this.onDidChangeFilter}) {
    this._initialMonth =
        _isMonthValidForYear(initialMonth, initialYear) ? initialMonth : 0;
    this._initialYear =
        _years.contains(initialYear) ? initialYear : _years.last;
  }

  @override
  State<YtdFilter> createState() =>
      _YtdFilterState(_initialMonth, _initialYear);

  bool _isMonthValidForYear(int month, int year) {
    if (month < AppYears().currentAndPastMonthsOfYear(year).length) return true;

    return false;
  }
}

class _YtdFilterState extends State<YtdFilter> {
  int _selectedMonth;
  int _selectedYear;

  _YtdFilterState(initialMonth, int initialYear)
      : _selectedMonth = initialMonth,
        _selectedYear = initialYear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: DropdownFilter(
            items: _getMonthNamesForSelectedYear(),
            selectedValue: _getSelectedMonthName(),
            textStyle: TextStyles.largeTitleTextStyleBold
                .copyWith(color: AppColors.defaultColor),
            backgroundColor: Colors.white,
            dropdownColor: AppColors.filtersBackgroundColor,
            dropdownArrowColor: AppColors.defaultColor,
            onDidSelectedItemAtIndex: (month) => _selectMonth(month),
          ),
        ),
        SizedBox(
          width: 90,
          child: DropdownFilter(
            items: _getYears(),
            selectedValue: _getSelectedYear(),
            textStyle: TextStyles.largeTitleTextStyleBold
                .copyWith(color: AppColors.defaultColor),
            backgroundColor: Colors.white,
            dropdownColor: AppColors.filtersBackgroundColor,
            dropdownArrowColor: AppColors.defaultColor,
            onDidSelectedItemAtIndex: (index) => _selectYearAtIndex(index),
          ),
        ),
      ],
    );
  }

  //MARK: Functions to get months and years

  List<String> _getMonthNamesForSelectedYear() {
    var years = AppYears().currentAndPastShortenedMonthsOfYear(_selectedYear);
    years.insert(0, "YTD");
    return years;
  }

  List<String> _getYears() {
    return widget._years.map((e) => "$e").toList();
  }

  //MARK: Functions to select month and year

  void _selectMonth(int month) {
    setState(() => _selectedMonth = month);
    widget.onDidChangeFilter(_selectedMonth, _selectedYear);
  }

  void _selectYearAtIndex(int index) {
    setState(() {
      _selectedYear = widget._years[index];
      if (!widget._isMonthValidForYear(_selectedMonth, _selectedYear))
        _selectedMonth = 0;
    });
    widget.onDidChangeFilter(_selectedMonth, _selectedYear);
  }

  //MARK: Function to get selected month and year

  String _getSelectedMonthName() {
    return _getMonthNamesForSelectedYear()[_selectedMonth];
  }

  String _getSelectedYear() {
    return "$_selectedYear";
  }
}
