import 'dart:core';

class AppYears {
  int _startYear = 2015;
  List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<int> years() {
    List<int> years = [];
    var currentYear = DateTime.now().year;
    for (int i = _startYear; i <= currentYear; i++) {
      years.add(i);
    }
    return years;
  }

  int getCurrentYear() {
    return years().last;
  }

  String getCurrentMonth() {
    return _monthNames[DateTime.now().month - 1];
  }

  List<String> currentAndPastMonthsOfYear(int year) {
    if (year == DateTime.now().year) {
      return _monthNames.sublist(0, DateTime.now().month);
    } else
      return _monthNames;
  }

  List<String> currentAndPastShortenedMonthsOfYear(int year) {
    return currentAndPastMonthsOfYear(year).map((m) => _shortenedMonthName(m)).toList();
  }

  /// 1 = Jan
  /// 2 = Feb
  /// ...
  /// 12 = Dec
  String getShortNameForMonth(int month) {
    return _shortenedMonthName(_monthNames[month - 1]);
  }

  String _shortenedMonthName(String month) {
    return month.substring(0, 3);
  }

  String yearAndMonthAsYtdString(int year, int month) {
    String label = "";
    if (month == 0) {
      label = "YTD";
    } else {
      label += "${getShortNameForMonth(month)} $year";
    }
    return label;
  }
}
