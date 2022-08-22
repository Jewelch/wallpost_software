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

  List<String> currentAndPastMonthsOfTheCurrentYear(int year) {
    if (year == DateTime.now().year) {
      return _monthNames.sublist(0, DateTime.now().month);
    } else
      return _monthNames;
  }

  String getCurrentMonth() {
    return _monthNames[DateTime.now().month];
  }
}
