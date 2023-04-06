import 'package:wallpost/_shared/date_range_selector/entities/selectable_date_range_option.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';

class DateRange {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  SelectableDateRangeOptions selectedRangeOption = SelectableDateRangeOptions.today;

  DateRange();

  void applyToday() {
    selectedRangeOption = SelectableDateRangeOptions.today;
    endDate = DateTime.now();
    startDate = DateTime.now();
  }

  void applyYesterday() {
    selectedRangeOption = SelectableDateRangeOptions.yesterday;
    var yesterday = DateTime.now().subtract(Duration(days: 1));
    endDate = yesterday;
    startDate = yesterday;
  }

  void applyThisWeek() {
    selectedRangeOption = SelectableDateRangeOptions.thisWeek;
    endDate = DateTime.now();
    var recentMonday = DateTime(endDate.year, endDate.month, endDate.day - (endDate.weekday - 1));
    startDate = recentMonday;
  }

  void applyThisMonth() {
    selectedRangeOption = SelectableDateRangeOptions.thisMonth;
    endDate = DateTime.now();
    startDate = DateTime(endDate.year, endDate.month, 1);
  }

  void applyThisYear() {
    selectedRangeOption = SelectableDateRangeOptions.thisYear;
    endDate = DateTime.now();
    startDate = DateTime(endDate.year, 1, 1);
  }

  void applyLastYear() {
    selectedRangeOption = SelectableDateRangeOptions.lastYear;
    var today = DateTime.now();
    startDate = DateTime(today.year - 1, 1, 1);
    endDate = DateTime(today.year - 1, 12, 31);
  }

  void applyCustomDate(DateTime startDay, DateTime endDay) {
    selectedRangeOption = SelectableDateRangeOptions.custom;
    startDate = startDay;
    endDate = endDay;
  }

  String toReadableString() {
    switch (this.selectedRangeOption) {
      case SelectableDateRangeOptions.today:
        return "Today";
      case SelectableDateRangeOptions.yesterday:
        return "Yesterday";
      case SelectableDateRangeOptions.thisWeek:
        return "This Week";
      case SelectableDateRangeOptions.thisMonth:
        return "This Month";
      case SelectableDateRangeOptions.thisYear:
        return "This Year";
      case SelectableDateRangeOptions.lastYear:
        return "Last Year";
      case SelectableDateRangeOptions.custom:
        return startDate.toReadableStringWithHyphens() + " to " + endDate.toReadableStringWithHyphens();
    }
  }

  DateRange copy() {
    var copyDateRangeFilter = DateRange();
    copyDateRangeFilter.selectedRangeOption = selectedRangeOption;
    copyDateRangeFilter.startDate = startDate;
    copyDateRangeFilter.endDate = endDate;
    return copyDateRangeFilter;
  }

  @override
  bool operator ==(Object other) {
    if (other is! DateRange) return false;
    if (other.selectedRangeOption != selectedRangeOption) return false;
    if (other.selectedRangeOption == SelectableDateRangeOptions.custom) {
      if (other.startDate.toIso8601String() != startDate.toIso8601String()) return false;
      if (other.endDate.toIso8601String() != endDate.toIso8601String()) return false;
    }
    return true;
  }

  @override
  int get hashCode => super.hashCode;
}
