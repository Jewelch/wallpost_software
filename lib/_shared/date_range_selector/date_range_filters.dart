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
    return this == SelectableDateRangeOptions.custom || this == SelectableDateRangeOptions.thisMonth
        ? 'date_between'
        : this.toReadableString().replaceAll(' ', '_').toLowerCase();
  }
}

class DateRangeFilters {
  SelectableDateRangeOptions _selectedRangeOption = SelectableDateRangeOptions.today;

  SelectableDateRangeOptions get selectedRangeOption => _selectedRangeOption;

  DateTime startDate = DateTime.now().subtract(Duration(days: 356));
  DateTime endDate = DateTime.now();

  void setSelectedDateRangeOption(SelectableDateRangeOptions selectableDateRangeOptions) {
    if (selectableDateRangeOptions == SelectableDateRangeOptions.thisMonth) {
      endDate = DateTime.now();
      startDate = startDate.subtract(Duration(days: 30));
    }
    this._selectedRangeOption = selectableDateRangeOptions;
  }

  DateRangeFilters copy() {
    var copyDateRangeFilter = DateRangeFilters();
    copyDateRangeFilter._selectedRangeOption = selectedRangeOption;
    copyDateRangeFilter.startDate = startDate;
    copyDateRangeFilter.endDate = endDate;
    return copyDateRangeFilter;
  }

  @override
  bool operator ==(Object other) {
    if (other is! DateRangeFilters) return false;
    if (other.selectedRangeOption == SelectableDateRangeOptions.custom) {
      if (other.startDate != startDate || other.endDate != endDate) return false;
      return true;
    }
    return other.selectedRangeOption == selectedRangeOption;
  }

  @override
  int get hashCode => super.hashCode;

}
