import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/my_portal/entities/employee_performance.dart';

import '../mocks.dart';

void main() {
  test('ytd performance is set to 0 if it is null', () async {
    var response = Mocks.employeePerformanceResponse;
    response['ytd_performance'] = null;

    var employeePerformance = EmployeePerformance.fromJson(response);

    expect(employeePerformance.overallYearlyPerformancePercent, 0);
  });
}
