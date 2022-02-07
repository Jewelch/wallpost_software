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
  List<AttendanceAdjustmentForm> attendanceAdjustmentForms = [];


  setUpAll(() {
    when(() => mockEmployee.companyId).thenReturn('someCompanyId');
    when(() => mockEmployee.v1Id).thenReturn('v1EmpId');
    when(() => mockAttendanceAdjustmentForm.toJson()).thenReturn({'adjustments': []});
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

    var _ = await attendanceAdjustmentSubmitter.submitAdjustment(attendanceAdjustmentForms);

    expect(
        mockNetworkAdapter.apiRequest.url,
        AttendanceAdjustmentUrls.submitAdjustmentUrl(
            'someCompanyId', 'v1EmpId'));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await attendanceAdjustmentSubmitter
          .submitAdjustment(attendanceAdjustmentForms);

      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      var _ = await attendanceAdjustmentSubmitter
          .submitAdjustment(attendanceAdjustmentForms);
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed',
      () async {
    mockNetworkAdapter.succeed(successfulResponse);

    attendanceAdjustmentSubmitter
        .submitAdjustment(attendanceAdjustmentForms);

    expect(attendanceAdjustmentSubmitter.isLoading, true);
  });
}
