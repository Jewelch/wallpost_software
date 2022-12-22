import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/finance/ui/presenters/finance_filter_presenter.dart';

void main() {
  late FinanceFiltersPresenter presenter;

  setUp(() {
    presenter = FinanceFiltersPresenter(initialMonth: 0, initialYear: 2022);
  });

  test('initialize month and year when selected  ytd ', () async {
    int ytdIndex = -1;
    presenter = FinanceFiltersPresenter(initialMonth: 0, initialYear: 2022);
    expect(presenter.selectedYear, 2022);
    expect(presenter.selectedMonth, ytdIndex);
  });

  test('initialize month and year ', () async {
    int monthIndex = 2;
    presenter = FinanceFiltersPresenter(initialMonth: 3, initialYear: 2022);
    expect(presenter.selectedYear, 2022);
    expect(presenter.selectedMonth, monthIndex);
  });

  test('set selected filter year', () async {
    presenter.setFilterYear(2021);

    expect(presenter.selectedYear, 2021);
  });

  test('set selected filter month', () async {
    presenter.setFilterMonth(2);

    expect(presenter.selectedMonth, 2);
  });

  test('show background color to app color when selected data ', () async {
    int index = presenter.years.indexOf(2022);
    presenter.setFilterYear(2022);
    expect(presenter.getYearItemBackgroundColor(index), AppColors.defaultColor);
  });

  test('show background color to default when unselect data ', () async {
    int index = presenter.years.indexOf(2022);
    presenter.setFilterYear(2021);
    expect(presenter.getYearItemBackgroundColor(index), Colors.transparent);
  });

  test('show text color to white when selected item', () async {
    int index = presenter.years.indexOf(2022);
    presenter.setFilterYear(2022);
    expect(presenter.getYearItemTextColor(index), Colors.white);
  });

  test('show text color to default when unselected  item', () async {
    int index = presenter.years.indexOf(2022);
    presenter.setFilterYear(2021);
    expect(presenter.getYearItemTextColor(index), AppColors.textColorGray);
  });

  test('show month background color to app color when selected data ', () async {
    presenter.setFilterYear(2022);
    int index = presenter.getMonthNamesForSelectedYear().indexOf('Feb');
    presenter.setFilterMonth(1);
    expect(presenter.getMonthItemBackgroundColor(index), AppColors.defaultColor);
  });

  test('show month background color to default when unselected data ', () async {
    presenter.setFilterYear(2022);
    presenter.setFilterMonth(2);
    expect(presenter.getMonthItemBackgroundColor(1), Colors.transparent);
  });

  test('show month text color to white when selected data ', () async {
    presenter.setFilterYear(2022);
    int index = presenter.getMonthNamesForSelectedYear().indexOf('Mar');
    presenter.setFilterMonth(2);
    expect(presenter.getMonthItemTextColor(index), Colors.white);
  });

  test('show month text color to default when unselected data ', () async {
    presenter.setFilterYear(2022);
    presenter.setFilterMonth(2);
    expect(presenter.getMonthItemTextColor(3), AppColors.textColorGray);
  });

  test('get month names for the selected year', () async {
    List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    presenter.setFilterYear(2022);
    expect(presenter.getMonthNamesForSelectedYear(), months);
  });

  test('check month count', () async {
    presenter.setFilterYear(2022);
    expect(presenter.getMonthCountForTheSelectedYear(), 12);
  });

  test('return true when month is valid for the year ', () async {
    expect(presenter.isMonthValidForYear(1, 2022), true);
  });

  test('return false when month is not valid for the year', () async {
    expect(presenter.isMonthValidForYear(13, 2022), false);
  });
}
