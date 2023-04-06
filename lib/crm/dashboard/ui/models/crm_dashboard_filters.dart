import 'package:wallpost/_shared/constants/app_years.dart';

class CrmDashboardFilters {
  int month = 0;
  int year = AppYears().getCurrentYear();
  var performanceType = PerformanceType.staffPerformance;
}

enum PerformanceType {
  staffPerformance,
  servicePerformance;

  String toReadableString() {
    if (this == PerformanceType.staffPerformance) {
      return "Staff";
    } else {
      return "Service";
    }
  }
}
