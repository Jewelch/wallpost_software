import 'package:wallpost/_shared/constants/app_years.dart';

class OwnerDashboardFilters {
  int month = 0;
  int year = AppYears().getCurrentYear();

  String getMontYearString() {
    String label = "";
    if (month == 0) {
      if (year == AppYears().getCurrentYear()) {
        label = "YTD";
      } else {
        label = "YTD $year";
      }
    } else {
      label += "${AppYears().getShortNameForMonth(month)} $year";
    }
    return label;
  }
}
