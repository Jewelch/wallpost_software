import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/attendance__core/entities/attendance_status.dart';
import 'package:wallpost/attendance/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance/attendance_adjustment/services/attendance_adjustment_submitter.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_employee.dart';
import '../../../_mocks/mock_network_adapter.dart';

void main() {
  Map<String, dynamic> successfulResponse = {};
  late AttendanceAdjustmentForm adjustmentForm;
  var mockEmployee = MockEmployee();
  var mockCompanyProvider = MockCompanyProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var attendanceAdjustmentSubmitter = AttendanceAdjustmentSubmitter.initWith(
    mockCompanyProvider,
    mockNetworkAdapter,
  );

  setUpAll(() {
    var company = MockCompany();
    when(() => company.id).thenReturn('someCompanyId');
    when(() => company.employee).thenReturn(mockEmployee);
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);

    var attendanceDate = DateTime(2020, 1, 1);
    TimeOfDay adjustedPunchInTime = TimeOfDay(hour: 8, minute: 0);
    TimeOfDay adjustedPunchOutTime = TimeOfDay(hour: 17, minute: 0);
    var adjustedStatus = AttendanceStatus.Present;
    adjustmentForm = AttendanceAdjustmentForm(
      "someAttendanceId",
      "someCompanyId",
      "v1EmpId",
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
      'attendance_id': "someAttendanceId",
      'date': '2020-01-01',
      'reason': "some work",
      'adjusted_punchin': '08:00',
      'adjusted_punchout': '17:00',
      'adjusted_status': 'PRESENT',
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

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    await attendanceAdjustmentSubmitter.submitAdjustment(adjustmentForm);

    expect(attendanceAdjustmentSubmitter.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      await attendanceAdjustmentSubmitter.submitAdjustment(adjustmentForm);
      fail('failed to throw exception');
    } catch (_) {
      expect(attendanceAdjustmentSubmitter.isLoading, false);
    }
  });
}
