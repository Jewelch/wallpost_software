class FinanceFilterData {
  // SelectableDateRangeOptions _selectedRangeOption = SelectableDateRangeOptions.today;
  //
  // SelectableDateRangeOptions get selectedRangeOption => _selectedRangeOption;

  String? year;
  String? month;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // void setSelectedDateRangeOption(SelectableDateRangeOptions selectableDateRangeOptions) {
  //   if (selectableDateRangeOptions == SelectableDateRangeOptions.thisMonth) {
  //     endDate = DateTime.now();
  //     startDate = startDate.subtract(Duration(days: 30));
  //   }
  //   this._selectedRangeOption = selectableDateRangeOptions;
  // }

  FinanceFilterData copy() {
    var copyDateRangeFilter = FinanceFilterData();
   // copyDateRangeFilter._selectedRangeOption = selectedRangeOption;
    copyDateRangeFilter.year="2022";
    copyDateRangeFilter.startDate = startDate;
    copyDateRangeFilter.endDate = endDate;
    return copyDateRangeFilter;
  }
}