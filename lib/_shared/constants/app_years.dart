import 'dart:core';

class AppYears {
  static int _startYear = 2015;
  static List<String> _monthNames = [
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

  static List<int> years() {
    List<int> years = [];
    var currentYear = DateTime.now().year;
    for (int i = currentYear; i >= _startYear; i--) {
      years.add(i);
    }
    return years;
  }

  static List<String> currentAndPastMonthsOfTheCurrentYear(int year) {
    if (year == DateTime.now().year) {
      return _monthNames.sublist(0, DateTime.now().month);
    } else
      return _monthNames;
  }

  static String getCurrentMonth() {
    return _monthNames[DateTime.now().month];
  }
}
