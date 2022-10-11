enum SelectableDateRangeOptions {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  thisYear,
  lastYear,
  custom;

  String toReadableString() {
    switch (this) {
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
        return "Custom";
    }
  }

  String toRawString() {
    return this == SelectableDateRangeOptions.custom ? 'date' : this.toReadableString().replaceAll(' ', '_').toLowerCase();
  }

}

class DateRangeFilters {
  List<SelectableDateRangeOptions> selectableOptions = SelectableDateRangeOptions.values;
  SelectableDateRangeOptions selectedDateOption = SelectableDateRangeOptions.today;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
}
