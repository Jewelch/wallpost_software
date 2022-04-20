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

  static List<String> monthNames(int year) {
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    if(year == DateTime.now().year) {
      return months.sublist(0, DateTime.now().month);
    }
    else
      return months;
  }
}
