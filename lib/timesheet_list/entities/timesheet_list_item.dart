class TimesheetListItem {
  final String title;
  final String subTitle;
  final double remainingHours;
  final DateTime? clockInTime;

  TimesheetListItem(
    this.title,
    this.subTitle,
    this.remainingHours,
    this.clockInTime,
  );

  bool isClockedIn() {
    return clockInTime != null;
  }
}
