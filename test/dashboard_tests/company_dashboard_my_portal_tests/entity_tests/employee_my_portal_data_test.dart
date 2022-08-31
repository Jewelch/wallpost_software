import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/dashboard/company_dashboard_my_portal/entities/employee_my_portal_data.dart';

import '../mocks.dart';

void main() {
  test('cutoff percentages', () {
    var data = EmployeeMyPortalData.fromJson(Mocks.employeeMyPortalDataResponse);

    expect(data.lowPerformanceCutoff(), 65);
    expect(data.mediumPerformanceCutoff(), 79);
  });

  group('ytd performance tests', () {
    test('low ytd performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['ytd_performance'] = 40;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isYTDPerformanceLow(), true);
      expect(data.isYTDPerformanceMedium(), false);
      expect(data.isYTDPerformanceHigh(), false);
    });

    test('medium ytd performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['ytd_performance'] = 75;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isYTDPerformanceLow(), false);
      expect(data.isYTDPerformanceMedium(), true);
      expect(data.isYTDPerformanceHigh(), false);
    });

    test('high ytd performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['ytd_performance'] = 90;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isYTDPerformanceLow(), false);
      expect(data.isYTDPerformanceMedium(), false);
      expect(data.isYTDPerformanceHigh(), true);
    });
  });

  group('current month performance tests', () {
    test('low current month performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_performance'] = 40;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthPerformanceLow(), true);
      expect(data.isCurrentMonthPerformanceMedium(), false);
      expect(data.isCurrentMonthPerformanceHigh(), false);
    });

    test('medium current month performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_performance'] = 75;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthPerformanceLow(), false);
      expect(data.isCurrentMonthPerformanceMedium(), true);
      expect(data.isCurrentMonthPerformanceHigh(), false);
    });

    test('high current month performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_performance'] = 90;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthPerformanceLow(), false);
      expect(data.isCurrentMonthPerformanceMedium(), false);
      expect(data.isCurrentMonthPerformanceHigh(), true);
    });
  });

  group('current month performance tests', () {
    test('low current month performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_performance'] = 40;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthPerformanceLow(), true);
      expect(data.isCurrentMonthPerformanceMedium(), false);
      expect(data.isCurrentMonthPerformanceHigh(), false);
    });

    test('medium current month performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_performance'] = 75;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthPerformanceLow(), false);
      expect(data.isCurrentMonthPerformanceMedium(), true);
      expect(data.isCurrentMonthPerformanceHigh(), false);
    });

    test('high current month performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_performance'] = 90;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthPerformanceLow(), false);
      expect(data.isCurrentMonthPerformanceMedium(), false);
      expect(data.isCurrentMonthPerformanceHigh(), true);
    });
  });

  group('current month attendance performance tests', () {
    test('low current month attendance performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_attendance_percentage'] = 40;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthAttendancePerformanceLow(), true);
      expect(data.isCurrentMonthAttendancePerformanceMedium(), false);
      expect(data.isCurrentMonthAttendancePerformanceHigh(), false);
    });

    test('medium current month attendance performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_attendance_percentage'] = 75;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthAttendancePerformanceLow(), false);
      expect(data.isCurrentMonthAttendancePerformanceMedium(), true);
      expect(data.isCurrentMonthAttendancePerformanceHigh(), false);
    });

    test('high current month attendance performance', () {
      var lowPerformanceMap = Mocks.employeeMyPortalDataResponse;
      lowPerformanceMap['current_month_attendance_percentage'] = 90;

      var data = EmployeeMyPortalData.fromJson(lowPerformanceMap);

      expect(data.isCurrentMonthAttendancePerformanceLow(), false);
      expect(data.isCurrentMonthAttendancePerformanceMedium(), false);
      expect(data.isCurrentMonthAttendancePerformanceHigh(), true);
    });
  });
}
