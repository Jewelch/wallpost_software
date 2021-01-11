import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/entities/leave_type.dart';

class MockLeaveType extends Mock implements LeaveType {}

class MockLeaveEmployee extends Mock implements LeaveEmployee {}

void main() {
  test('defaults', () async {
    var filters = LeaveListFilters();

    expect(filters.fromDateString, null);
    expect(filters.toDateString, null);
    expect(filters.leaveType, null);
    expect(filters.applicants, isEmpty);
  });

  test('show current leaves', () async {
    var filters = LeaveListFilters();

    filters.showCurrentLeaves();

    var expectedFromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    expect(filters.fromDateString, expectedFromDate);
    expect(filters.toDateString, null);
  });

  test('show leave history', () async {
    var filters = LeaveListFilters();

    filters.showLeaveHistory();

    var expectedToDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    expect(filters.fromDateString, null);
    expect(filters.toDateString, expectedToDate);
  });

  test('show all leaves', () async {
    var filters = LeaveListFilters();

    filters.showAllLeaves();

    expect(filters.fromDateString, null);
    expect(filters.toDateString, null);
  });

  test('resetting filters', () async {
    var filters = LeaveListFilters();
    filters.showCurrentLeaves();
    filters.leaveType = MockLeaveType();
    filters.applicants.add(MockLeaveEmployee());

    filters.reset();

    expect(filters.fromDateString, null);
    expect(filters.toDateString, null);
    expect(filters.leaveType, null);
    expect(filters.applicants, isEmpty);
  });
}


//TODO: Obaid

add _didReachListEnd = false; for each list provider service before making the API call