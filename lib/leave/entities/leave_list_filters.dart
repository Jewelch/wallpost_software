import 'package:intl/intl.dart';

import 'leave_employee.dart';
import 'leave_type.dart';

class LeaveListFilters {
  DateTime _fromDate;
  DateTime _toDate;
  LeaveType leaveType;
  List<LeaveEmployee> applicants = [];

  void showCurrentLeaves() {
    _fromDate = DateTime.now();
    _toDate = null;
  }

  void showLeaveHistory() {
    _fromDate = null;
    _toDate = DateTime.now();
  }

  void showAllLeaves() {
    _fromDate = null;
    _toDate = null;
  }

  void reset() {
    _fromDate = null;
    _toDate = null;
    leaveType = null;
    applicants.clear();
  }

  void resetSelectedLeaveType() {
    leaveType = null;
  }

  void resetSelectedApplicant() {
    applicants = [];
  }

  String get fromDateString =>
      _fromDate != null ? DateFormat('yyyy-MM-dd').format(_fromDate) : null;

  String get toDateString =>
      _toDate != null ? DateFormat('yyyy-MM-dd').format(_toDate) : null;

  LeaveListFilters clone() {
    var filters = LeaveListFilters();
    filters.leaveType = this.leaveType;
    filters.applicants.addAll(this.applicants);
    return filters;
  }
}
