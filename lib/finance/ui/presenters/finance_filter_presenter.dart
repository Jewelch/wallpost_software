import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../_shared/constants/app_colors.dart';
import '../../../_shared/constants/app_years.dart';

class FinanceFiltersPresenter {
  final _years = AppYears().years().reversed.toList();

  late int _selectedMonth;
  late int _selectedYear;
  int _ytdIndex = -1;

  FinanceFiltersPresenter({
    required initialMonth,
    required initialYear,
  }) {
    this._selectedMonth = isMonthValidForYear(initialMonth - 1, initialYear) ? initialMonth - 1 : _ytdIndex;
    this._selectedYear = _years.contains(initialYear) ? initialYear : _years.last;
  }

  setFilterYear(int year) {
    this._selectedYear = year;
  }

  setFilterMonth(int month) {
    this._selectedMonth = month;
  }

  //MARK: Setters

  int get selectedYear => _selectedYear;

  int get selectedMonth => _selectedMonth;

  List<int> get years => _years;

  bool shouldShowMoreMonthButton() {
    return getMonthNamesForSelectedYear().length > 5;
  }

  //MARK: Getters

  Color getYearItemBackgroundColor(int index) {
    return (_years[index] == _selectedYear) ? AppColors.defaultColor : Colors.transparent;
  }

  Color getYearItemTextColor(int index) {
    return (_years[index] == _selectedYear) ? Colors.white : AppColors.textColorGray;
  }

  Color getMonthItemBackgroundColor(int index) {
    return (index == _selectedMonth) ? AppColors.defaultColor : Colors.transparent;
  }

  Color getMonthItemTextColor(int index) {
    return (index == _selectedMonth) ? Colors.white : AppColors.textColorGray;
  }

  bool isMonthValidForYear(int month, int year) {
    if (month < AppYears().currentAndPastMonthsOfYear(year).length) return true;
    return false;
  }

  List<String> getMonthNamesForSelectedYear() {
    var years = AppYears().currentAndPastShortenedMonthsOfYear(_selectedYear);
    return years;
  }

  int getMonthCountForTheSelectedYear() {
    var monthCount = AppYears().currentAndPastShortenedMonthsOfYear(_selectedYear).length;
    return monthCount;
  }
}
