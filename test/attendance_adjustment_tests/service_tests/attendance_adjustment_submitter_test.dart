import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

void main() {
  Map<String, dynamic> successfulResponse = {};
  late AttendanceAdjustmentForm adjustmentForm;
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var attendanceAdjustmentSubmitter = AttendanceAdjustmentSubmitter.initWith(mockEmployeeProvider, mockNetworkAdapter);

  setUpAll(() {
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser()).thenReturn(mockEmployee);

    var attendanceDate = DateTime(2020, 1, 1);
    TimeOfDay adjustedPunchInTime = TimeOfDay(hour: 8, minute: 0);
    TimeOfDay adjustedPunchOutTime =  TimeOfDay(hour: 17, minute: 0);
    var adjustedStatus = AttendanceStatus.Present;
    adjustmentForm = AttendanceAdjustmentForm(
      mockEmployee,
      attendanceDate,
      "some work",
      adjustedPunchInTime,
      adjustedPunchOutTime,
      adjustedStatus,
    );
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built correctly', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceAdjustmentSubmitter.submitAdjustment(adjustmentForm);

    expect(mockNetworkAdapter.apiRequest.url, AttendanceAdjustmentUrls.submitAdjustmentUrl('someCompanyId', 'v1EmpId'));
    expect(mockNetworkAdapter.apiRequest.parameters, {
      'attendance_id': null,
      'date': '2020-01-01',
      'reason': "some work",
      'adjusted_punchin': '08:00',
      'adjusted_punchout': '17:00',
      'adjusted_status': 'present',
      'employee_id': 'v1EmpId',
      'company_id': 'someCompanyId',
    });
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceAdjustmentSubmitter.submitAdjustment(adjustmentForm);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await attendanceAdjustmentSubmitter.submitAdjustment(adjustmentForm);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceAdjustmentSubmitter.submitAdjustment(adjustmentForm);

    expect(attendanceAdjustmentSubmitter.isLoading, true);
  });
}
