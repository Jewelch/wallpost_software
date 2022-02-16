class AppYears {
  static int _startYear = 2015;

  static List<int> years() {
    List<int> years = [];
    var currentYear = DateTime.now().year;
    for (int i = currentYear; i >= _startYear; i--) {
      years.add(i);
    }
    return years;
  }

  static List<String> shortenedMonthNames() {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  }

  static List<String> shortenedMonthNamesForYear(int year) {
    //TODO Ameena
    //if year == current year = return months till the current month
    //else return shortenedMonthNames();
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  }
}
