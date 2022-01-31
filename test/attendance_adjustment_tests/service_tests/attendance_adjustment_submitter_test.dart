import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance_adjustment/constants/attendance_adjustment_urls.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_adjustment_form.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_adjustment_submitter.dart';

import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_employee_provider.dart';
import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceAdjustmentForm extends Mock
    implements AttendanceAdjustmentForm {}

void main() {
  Map<String, dynamic> successfulResponse = {};
  var mockAttendanceAdjustmentForm = MockAttendanceAdjustmentForm();
  var mockEmployee = MockEmployee();
  var mockEmployeeProvider = MockEmployeeProvider();
  var mockNetworkAdapter = MockNetworkAdapter();
  var attendanceAdjustmentSubmitter = AttendanceAdjustmentSubmitter.initWith(
      mockEmployeeProvider, mockNetworkAdapter);

  setUpAll(() {
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockAttendanceAdjustmentForm.toJson()).thenReturn({
      'date': 'date',
      'reason': 'reason',
      'adjusted_punchin': '08:00',
      'adjusted_punchout': '06:00'
    });
    when(() => mockEmployeeProvider.getSelectedEmployeeForCurrentUser())
        .thenReturn(mockEmployee);
  });

  setUp(() {
    mockNetworkAdapter.reset();
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    requestParams.addAll(mockAttendanceAdjustmentForm.toJson());
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await attendanceAdjustmentSubmitter
        .submitAdjustment(mockAttendanceAdjustmentForm);

    expect(
        mockNetworkAdapter.apiRequest.url,
        AttendanceAdjustmentUrls.submitAdjustmentUrl(
            'someCompanyId', 'v1EmpId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    // expect(mockNetworkAdapter.apiRequest.parameters['id'], null);
    // expect(mockNetworkAdapter.apiRequest.parameters['attendance_id'], 1);
    // expect(mockNetworkAdapter.apiRequest.parameters['work_status'], 'status');
    // expect(mockNetworkAdapter.apiRequest.parameters['punch_in_time'], '');
    // expect(mockNetworkAdapter.apiRequest.parameters['punch_out_time'], '');
    // expect(mockNetworkAdapter.apiRequest.parameters['approval_status'], 'null');
    // expect(mockNetworkAdapter.apiRequest.parameters['edit_mode'], false);
    // expect(
    //     mockNetworkAdapter.apiRequest.parameters['orig_punch_in_time'], null);
    // expect(
    //     mockNetworkAdapter.apiRequest.parameters['orig_punch_out_time'], null);
    // expect(
    //     mockNetworkAdapter.apiRequest.parameters['punch_in_time_error'], false);
    // expect(mockNetworkAdapter.apiRequest.parameters['punch_out_time_error'],
    //     false);
    // expect(mockNetworkAdapter.apiRequest.parameters['status_out_error'], false);
    // expect(mockNetworkAdapter.apiRequest.parameters['approver_name'], ' ');
    // expect(
    //     mockNetworkAdapter.apiRequest.parameters['attnce_reason_error'], false);
    // expect(mockNetworkAdapter.apiRequest.parameters['employee_id'], 'v1EmpId');
    // expect(mockNetworkAdapter.apiRequest.parameters['company_id'],
    //     'someCompanyId');
    // expect(
    //     mockNetworkAdapter.apiRequest.parameters['adjusted_status'], 'status');
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceAdjustmentSubmitter
          .submitAdjustment(mockAttendanceAdjustmentForm);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await attendanceAdjustmentSubmitter
          .submitAdjustment(mockAttendanceAdjustmentForm);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed',
      () async {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceAdjustmentSubmitter
        .submitAdjustment(mockAttendanceAdjustmentForm);

    expect(attendanceAdjustmentSubmitter.isLoading, true);
  });
}
