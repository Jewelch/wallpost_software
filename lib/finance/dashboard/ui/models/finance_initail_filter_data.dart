import 'package:wallpost/_shared/constants/app_years.dart';

class FinanceInitialFilterData {
  int month = 0;
  int year = AppYears().getCurrentYear();

  String getMonthYearString() {
    String label = "";
    if (month == 0) {
      label = "YTD";
    } else {
      label += "${AppYears().getShortNameForMonth(month - 1)} $year";
    }
    return label;
  }
}