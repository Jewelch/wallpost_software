// @dart=2.9

import 'package:random_string/random_string.dart';

class Mocks {
  static List<Map<String, dynamic>> noAttendanceResponse = [{}];

  static List<Map<String, dynamic>> punchedInAttendanceResponse = [
    {
      "attendance_details": [
        {
          "actual_punch_in": '2020-06-22 08:00:00',
          "actual_punch_out": null,
          "attendance_details_id": 'someAttendanceDetailsId',
          "duration": true,
          "punch_in": randomString(10),
          "punch_in_location": {
            "latitude": randomString(10),
            "longitude": randomString(10),
          },
          "punch_out": null,
          "punch_out_location": null,
          "punchin_invalid_location": randomString(10),
          "punchout_invalid_location": randomString(10),
        },
      ],
      "attendance_id": 'someAttendanceId',
      "date": randomString(10),
      "status_arrival": randomString(10),
      "status_leave": randomString(10),
      "work_status": randomString(10),
    },
  ];

  static List<Map<String, dynamic>> punchedInAttendanceWithActiveBreakResponse = [
    {
      "attendance_details": [
        {
          "actual_punch_in": '2020-06-22 08:00:00',
          "actual_punch_out": null,
          "attendance_details_id": 'someAttendanceDetailsId',
          "attendance_intervals": [
            {
              "actual_break_in": '2020-06-22 13:00:00',
              "actual_break_out": null,
              "attendance_details_id": randomString(10),
              "break_in": randomString(10),
              "break_in_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "break_out": randomString(10),
              "break_out_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "duration": true,
              "interval_id": 'someBreakId',
            },
            {
              "actual_break_in": '2020-06-22 13:00:00',
              "actual_break_out": '2020-06-22 13:15:00',
              "attendance_details_id": randomString(10),
              "break_in": randomString(10),
              "break_in_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "break_out": randomString(10),
              "break_out_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "duration": true,
              "interval_id": randomString(10),
            },
            {
              "actual_break_in": '2020-06-22 13:00:00',
              "actual_break_out": '2020-06-22 13:15:00',
              "attendance_details_id": randomString(10),
              "break_in": randomString(10),
              "break_in_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "break_out": randomString(10),
              "break_out_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "duration": true,
              "interval_id": randomString(10),
            },
          ],
          "duration": true,
          "punch_in": randomString(10),
          "punch_in_location": {
            "latitude": randomString(10),
            "longitude": randomString(10),
          },
          "punch_out": null,
          "punch_out_location": null,
          "punchin_invalid_location": randomString(10),
          "punchout_invalid_location": randomString(10),
        },
      ],
      "attendance_id": 'someAttendanceId',
      "date": randomString(10),
      "status_arrival": randomString(10),
      "status_leave": randomString(10),
      "work_status": randomString(10),
    },
  ];

  static List<Map<String, dynamic>> punchedOutAttendanceDetailsResponse = [
    {
      "attendance_details": [
        {
          "actual_punch_in": '2020-06-22 08:00:00',
          "actual_punch_out": '2020-06-22 17:00:00',
          "attendance_details_id": 'someAttendanceDetailsId',
          "attendance_intervals": [
            {
              "actual_break_in": '2020-06-22 13:00:00',
              "actual_break_out": null,
              "attendance_details_id": randomString(10),
              "break_in": randomString(10),
              "break_in_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "break_out": randomString(10),
              "break_out_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "duration": true,
              "interval_id": randomString(10),
            },
            {
              "actual_break_in": '2020-06-22 13:00:00',
              "actual_break_out": '2020-06-22 13:15:00',
              "attendance_details_id": randomString(10),
              "break_in": randomString(10),
              "break_in_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "break_out": randomString(10),
              "break_out_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "duration": true,
              "interval_id": randomString(10),
            },
            {
              "actual_break_in": '2020-06-22 13:00:00',
              "actual_break_out": '2020-06-22 13:15:00',
              "attendance_details_id": randomString(10),
              "break_in": randomString(10),
              "break_in_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "break_out": randomString(10),
              "break_out_location": {
                "latitude": randomString(10),
                "longitude": randomString(10),
              },
              "duration": true,
              "interval_id": randomString(10),
            },
          ],
          "duration": true,
          "punch_in": randomString(10),
          "punch_in_location": {
            "latitude": randomString(10),
            "longitude": randomString(10),
          },
          "punch_out": randomString(10),
          "punch_out_location": randomString(10),
          "punchin_invalid_location": randomString(10),
          "punchout_invalid_location": randomString(10),
        },
      ],
      "attendance_id": 'someAttendanceId',
      "date": randomString(10),
      "status_arrival": randomString(10),
      "status_leave": randomString(10),
      "work_status": randomString(10),
    },
  ];

  static List<Map<String, dynamic>> attendanceReportResponse = [
    {
      "Absents": 12,
      "actualMinutesWorked": randomBetween(1000, 5000),
      "Breaks": true,
      "DeductableAnnualLeavesCount": true,
      "DeductableNextPayrollAnnualLeavesCount": true,
      "DeductablePrevPayrollAnnualLeavesCount": true,
      "EarlyLeave": 43,
      "emp_id": randomBetween(1000, 5000),
      "emp_name": randomString(10),
      "employeeGenericShiftDurationInMinutes": randomBetween(1000, 5000),
      "employeeWorkingDuration": randomBetween(1000, 5000),
      "extraMinutesWorked": randomBetween(1000, 5000),
      "extraMinutesWorkedDistribution": {
        "night": true,
        "weekday": true,
        "weekend": true,
      },
      "GranularAbsent": true,
      "GranularAbsentTime": true,
      "Halfdays": true,
      "Holidays": true,
      "Late": 20,
      "Leaves": 123,
      "ot_minutes": true,
      "PenaltyBreakup": {
        "Absents": true,
        "EarlyAbsents": true,
        "HalfdayAbsents": true,
        "LateAbsents": true,
        "PunchInGranularAbsent": true,
        "PunchInGranularAbsentTime": true,
        "PunchOutGranularAbsent": true,
        "PunchOutGranularAbsentTime": true,
        "UnpaidLeaves": true,
      },
      "PenaltyDays": true,
      "Presents": 2103,
      "WorkingDays": randomBetween(1000, 5000),
    },
  ];

  static Map<String, dynamic> punchInFromAppPermissionResponse = {
    "punch_in_allowed": true,
  };

  static Map<String, dynamic> punchInNowPermissionResponse = {
    "remaining_in_min": randomBetween(1000, 5000),
    "status": true,
  };
}
