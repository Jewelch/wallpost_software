import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';

void main() {
  test("get years", () {
    int currentYear = DateTime.now().year;
    List<int> years = [];
    for (int i = 2015; i <= currentYear; i++) {
      years.add(i);
    }

    expect(AppYears().years(), years);
  });

  test("get current year", () {
    int currentYear = DateTime.now().year;

    expect(AppYears().getCurrentYear(), currentYear);
  });

  test("get current month", () {
    var currentMonth = DateFormat("MMMM").format(DateTime.now());

    expect(AppYears().getCurrentMonth(), currentMonth);
  });

  test("get current and past months of current year", () {
    var currentYear = DateTime.now().year;
    var currentMonth = DateTime.now().month;
    List<String> months = [];
    for (int i = 1; i <= currentMonth; i++) {
      var date = DateTime(currentYear, i, 1);
      months.add(DateFormat("MMMM").format(date));
    }

    expect(AppYears().currentAndPastMonthsOfYear(currentYear), months);
  });

  test("get current and past months of previous year", () {
    List<String> months = [];
    for (int i = 1; i <= 12; i++) {
      var date = DateTime(2018, i, 1);
      months.add(DateFormat("MMMM").format(date));
    }

    expect(AppYears().currentAndPastMonthsOfYear(2018), months);
  });

  test("get current and past shortened months of previous year", () {
    List<String> months = [];
    for (int i = 1; i <= 12; i++) {
      var date = DateTime(2018, i, 1);
      months.add(DateFormat("MMM").format(date).capitalize());
    }

    expect(AppYears().currentAndPastShortenedMonthsOfYear(2018), months);
  });

  test("get short name for month", () {
    expect(AppYears().getShortNameForMonth(1), "Jan");
    expect(AppYears().getShortNameForMonth(2), "Feb");
    expect(AppYears().getShortNameForMonth(3), "Mar");
    expect(AppYears().getShortNameForMonth(4), "Apr");
    expect(AppYears().getShortNameForMonth(5), "May");
    expect(AppYears().getShortNameForMonth(6), "Jun");
    expect(AppYears().getShortNameForMonth(7), "Jul");
    expect(AppYears().getShortNameForMonth(8), "Aug");
    expect(AppYears().getShortNameForMonth(9), "Sep");
    expect(AppYears().getShortNameForMonth(10), "Oct");
    expect(AppYears().getShortNameForMonth(11), "Nov");
    expect(AppYears().getShortNameForMonth(12), "Dec");
  });

  test("get ytd string for current year", () {
    int year = DateTime.now().year;
    int month = 0;

    expect(AppYears().yearAndMonthAsYtdString(year, month), "YTD");
  });

  test("get ytd string for current year and month", () {
    int year = DateTime.now().year;
    int month = 2;

    expect(AppYears().yearAndMonthAsYtdString(year, month), "Feb $year");
  });

  test("get ytd string for previous year", () {
    int year = 2018;
    int month = 0;

    expect(AppYears().yearAndMonthAsYtdString(year, month), "YTD $year");
  });

  test("get ytd string for previous year and month", () {
    int year = DateTime.now().year;
    int month = 4;

    expect(AppYears().yearAndMonthAsYtdString(year, month), "Apr $year");
  });
}
