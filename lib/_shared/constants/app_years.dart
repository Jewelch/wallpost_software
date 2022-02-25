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

  static List<String> shortenedMonthNames(int year) {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    if(year == DateTime.now().year) {
      return months.sublist(0, DateTime.now().month);
    }
    else
      return months;
  }
}
