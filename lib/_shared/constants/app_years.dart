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
}
