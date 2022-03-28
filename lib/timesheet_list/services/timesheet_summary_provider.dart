import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/timesheet_list/entities/timesheet_summary.dart';

class TimesheetSummaryProvider {
  Future<TimesheetSummary> getSummary() {
    //for success
    return Future.delayed(Duration(seconds: 1)).then(
      (onValue) => TimesheetSummary(100, 30, 40 / 5, 50.4),
    );

    //for failure
    return Future.delayed(Duration(seconds: 1)).then(
      (onValue) => throw MappingException("failed to load...."),
    );
  }
}
