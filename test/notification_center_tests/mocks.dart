import 'package:wallpost/notification_center/entities/push_notification.dart';

class Mocks {
  static Map<String, dynamic> notificationCountResponse = {
    "companies": [
      {
        "companyApprovalCount": 14,
        "company_info": {
          "company_id": 13,
          "account_no": 123123,
          "company_name": "Smart Management - Qatar",
          "short_name": "Smart Management - Qatar",
          "commercial_name": "Smart Management - Qatar",
          "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
          "js_date_format": "yyyy-mm-dd",
          "currency": "USD",
          "packages": ["hr", "task", "timesheet"],
          "is_trial": true,
        },
        "employee": {
          "employment_id": "gEBrqqLflxXRNQT",
          "name": "Obaid Mohamed",
          "designation": "IOS Developer",
          "email_id_office": "mahmed@wallpostsoftware.com",
          "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
          "employment_id_v1": 2123,
          "line_manager": "Ishaque Sethikunhi Ameen",
          "Roles": ["task_line_manager"],
        },
        "request_items": [
          {
            "display_name": "Disciplinary Action",
            "name": "disciplinary_request",
            "sub_module": "disciplinary_action",
            "visibility": true
          },
          {
            "display_name": "Employment Certificate",
            "name": "time_off_request",
            "sub_module": "time_off",
            "visibility": true
          },
          {
            "display_name": "Expense Request",
            "name": "expense_request",
            "sub_module": "expense_request",
            "visibility": true
          }
        ],
        "financial_summary": {
          "currency": "BGN",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "9.9M",
          "receivableOverdue": "32.3K",
          "payableOverdue": "67.3K",
          "profitLoss": "14.7K",
          "profitLossPerc": "51.854325587935"
        }
      },
      {
        "companyApprovalCount": 8,
        "company_info": {
          "company_id": 13,
          "account_no": 123123,
          "company_name": "Smart Management - Qatar",
          "short_name": "Smart Management - Qatar",
          "commercial_name": "Smart Management - Qatar",
          "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
          "js_date_format": "yyyy-mm-dd",
          "currency": "USD",
          "packages": ["hr", "task", "timesheet"],
          "is_trial": true,
        },
        "employee": {
          "employment_id": "gEBrqqLflxXRNQT",
          "name": "Obaid Mohamed",
          "designation": "IOS Developer",
          "email_id_office": "mahmed@wallpostsoftware.com",
          "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
          "employment_id_v1": 2123,
          "line_manager": "Ishaque Sethikunhi Ameen",
          "Roles": ["task_line_manager"],
        },
        "request_items": [
          {
            "display_name": "Disciplinary Action",
            "name": "disciplinary_request",
            "sub_module": "disciplinary_action",
            "visibility": true
          },
          {
            "display_name": "Employment Certificate",
            "name": "time_off_request",
            "sub_module": "time_off",
            "visibility": true
          },
          {
            "display_name": "Expense Request",
            "name": "expense_request",
            "sub_module": "expense_request",
            "visibility": true
          }
        ],
        "financial_summary": null,
      }
    ]
  };

  static var expenseApprovalRequiredNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/expense-approval-required",
  });

  static var expenseApprovedNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/expense-approved",
  });

  static var expenseRejectedNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/expense-rejected",
  });

  static var leaveApprovalRequiredNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/leave-approval-required",
  });

  static var leaveApprovedNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/leave-approved",
  });

  static var leaveRejectedNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/leave-rejected",
  });

  static var attendanceAdjustmentApprovalRequiredNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/attendance-adjustment-approval-required",
  });

  static var attendanceAdjustmentApprovedNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/attendance-adjustment-approved",
  });

  static var attendanceAdjustmentRejectedNotification = PushNotification.fromJson({
    "company_id": "12",
    "reference_id": "15",
    "route": "myportal://myportal/attendance-adjustment-rejected",
  });
}
