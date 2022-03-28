class TimesheetSummary {
  final num numberOfProjects;
  final double allocatedHours;
  final double usedHours;
  final double missingHoursThisWeek;

  TimesheetSummary(
    this.numberOfProjects,
    this.allocatedHours,
    this.usedHours,
    this.missingHoursThisWeek,
  );
}
