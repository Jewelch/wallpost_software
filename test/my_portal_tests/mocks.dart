import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> salesPerformanceResponse = {
    "oneYearback": {
      "actual": randomString(10),
      "actualChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "percentage": randomBetween(1000, 5000),
      "show": true,
      "target": randomString(10),
      "targetChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "year": 2019,
    },
    "selectedYear": {
      "actual": randomString(10),
      "actualChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "percentage": randomBetween(1000, 5000),
      "show": true,
      "target": randomString(10),
      "targetChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "year": '2020',
    },
    "twoYearback": {
      "actual": randomString(10),
      "actualChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "percentage": 80,
      "show": true,
      "target": randomString(10),
      "targetChart": [
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
        randomBetween(1000, 5000),
      ],
      "year": 2018,
    },
  };

  static Map<String, dynamic> employeePerformanceResponse = {
    "best": {
      "month": randomString(10),
      "score": '70',
    },
    "least": {
      "month": randomString(10),
      "score": '90',
    },
    "performance": randomBetween(1000, 5000),
    "ytd_performance": '89',
  };

  static Map<String, dynamic> pendingActionsCountResponse = {
    "alert": {
      "finance": {
        "count": randomBetween(1000, 5000),
        "detail": {
          "bill_due_this_week": randomString(10),
          "bill_due_today": randomString(10),
          "overdue_bill": randomString(10),
        },
      },
      "handover": {
        "count": randomBetween(1000, 5000),
        "detail": [
          {
            "id": randomBetween(1000, 5000),
            "leave_type_id": randomBetween(1000, 5000),
          },
        ],
      },
      "myportal": randomBetween(1000, 5000),
    },
    "approval": {
      "attendance_adjust": randomBetween(1000, 5000),
      "bill_request": randomBetween(1000, 5000),
      "expense_request": randomBetween(1000, 5000),
      "extensionPending": randomBetween(1000, 5000),
      "handover": 5,
      "invoice_request": randomBetween(1000, 5000),
      "journal_request": randomBetween(1000, 5000),
      "leave_encashment": randomBetween(1000, 5000),
      "leave_rejoin": randomBetween(1000, 5000),
      "leaves": 31,
      "overtime": randomBetween(1000, 5000),
      "overtime_adjust": randomBetween(1000, 5000),
      "payroll": randomBetween(1000, 5000),
      "preponePending": randomBetween(1000, 5000),
      "purchase_request": randomBetween(1000, 5000),
      "task": 10,
      "visa_letter": randomBetween(1000, 5000),
      "voucher_request": randomBetween(1000, 5000),
    },
    "approvals_to_hide": [
      randomString(10),
      randomString(10),
      randomString(10),
    ],
    "notifications": randomBetween(1000, 5000),
    "total_alerts": randomBetween(1000, 5000),
    "total_approvals": randomBetween(1000, 5000),
    "total_approvals_mob": randomBetween(1000, 5000),
  };
}
