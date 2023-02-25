import 'package:wallpost/_shared/extensions/date_extensions.dart';

enum SelectableDateRangeOptions {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  thisYear,
  lastYear,
  custom;

  String toSelectableString() {
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
        : this.toSelectableString().replaceAll(' ', '_').toLowerCase();
  }
}

class DateRangeFilters {
  SelectableDateRangeOptions _selectedRangeOption = SelectableDateRangeOptions.today;

  SelectableDateRangeOptions get selectedRangeOption => _selectedRangeOption;

  DateTime startDate = DateTime.now().subtract(Duration(days: 20));
  DateTime endDate = DateTime.now();

  void setSelectedDateRangeOption(SelectableDateRangeOptions selectableDateRangeOptions) {
    if (selectableDateRangeOptions == SelectableDateRangeOptions.thisMonth) {
      var today = DateTime.now();
      startDate = DateTime(today.year, today.month, 1);
      endDate = _getDateAfterOneMonthFrom(today);
    }
    this._selectedRangeOption = selectableDateRangeOptions;
  }

  DateTime _getDateAfterOneMonthFrom(DateTime date) {
    if (date.month == 12) {
      return DateTime(date.year + 1, 1, 1);
    } else {
      return DateTime(date.year, date.month + 1, 1);
    }
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
}
