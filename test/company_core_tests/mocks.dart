import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> companiesListResponse = {
    "groups": [
      {
        "group_id": 0,
        "name": "Group Summary",
        "default_currency": "USD",
        "is_default": 0,
        "group_companies": [
          "80",
          " 46",
          " 83",
          " 44",
          " 19",
          " 85",
          " 2",
          " 59",
        ],
        "group_summary": {
          "cashAvailability": "-17.6M",
          "receivableOverdue": "25B",
          "payableOverdue": "1.7M",
          "profitLoss": "-623.5M"
        }
      },
      {
        "group_id": 1,
        "name": "Partial Company",
        "default_currency": "USD",
        "is_default": 0,
        "group_companies": [
          "5",
          "44",
          "45",
          "59",
          "43",
        ],
        "group_summary": {
          "cashAvailability": "868.2K",
          "receivableOverdue": "2M",
          "payableOverdue": "235.4K",
          "profitLoss": "1.3M"
        }
      },
      {
        "group_id": 2,
        "name": "Manufacturing & Retail",
        "default_currency": "USD",
        "is_default": 1,
        "group_companies": [
          "2",
          "14",
          "15",
          "40",
          "19",
          "60",
          "63",
          "64",
          "76",
        ],
        "group_summary": {
          "cashAvailability": "-14.9M",
          "receivableOverdue": "10.4M",
          "payableOverdue": "1.1M",
          "profitLoss": "-13.6M"
        }
      },
    ],
    "companies": [
      {
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
          "approval_count": 8
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
          ]
        },
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
          "approval_count": 8
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
          ]
        },
        "financial_summary": null,
      }
    ]
  };

  static Map<String, dynamic> companyDetailsResponse = {
    "absolute_upload_path": randomString(10),
    "account_no": randomBetween(1000, 5000),
    "commercial_name": randomString(10),
    "company_id": 1234,
    "company_info": {
      "allowed_radius": randomBetween(1000, 5000),
      "approval_flow_settings": true,
      "calendar_settings": true,
      "change_company": true,
      "change_user": true,
      "client_auth_key": randomString(10),
      "company_name": randomString(10),
      "company_settings": true,
      "currency": randomString(10),
      "date_format": randomString(10),
      "date_separator": randomString(10),
      "date_time_settings": true,
      "employee_user_manager": true,
      "erp_access": randomString(10),
      "external_account_settings": true,
      "fullName": randomString(10),
      "has_signature": true,
      "is_trial": 'true',
      "js_date_format": randomString(10),
      "manage_wallpost": true,
      "packages": {
        "crm": {
          "features": randomString(10),
          "package": randomString(10),
          "users": randomString(10),
        },
        "finance": {
          "features": randomString(10),
          "package": randomString(10),
          "users": randomString(10),
        },
        "hr": {
          "features": randomString(10),
          "package": randomString(10),
          "users": randomString(10),
        },
        "performance": {
          "features": randomString(10),
          "package": randomString(10),
          "users": randomString(10),
        },
        "task": {
          "features": randomString(10),
          "package": randomString(10),
          "users": randomString(10),
        },
      },
      "pricing_url": randomString(10),
      "profile_image": randomString(10),
      "report_settings": true,
      "salutation": randomString(10),
      "setup_link": true,
      "show_calender_icon": true,
      "show_timesheet_icon": true,
      "switch_account": true,
      "time_zone": randomString(10),
      "user_id": randomString(10),
      "user_manager": true,
    },
    "company_logo": randomString(10),
    "company_name": randomString(10),
    "department_rank": {
      "out_of": randomBetween(1000, 5000),
      "rank": randomBetween(1000, 5000),
    },
    "employee": {
      "designation": randomString(10),
      "email_id_office": randomString(10),
      "employment_id": randomString(10),
      "employment_id_v1": randomBetween(1000, 5000),
      "image": randomString(10),
      "line_manager": randomString(10),
      "name": randomString(10),
      "Roles": [
        "general_manager",
        "owner",
      ],
    },
    "general_manager": randomBetween(1000, 5000),
    "owners": randomString(10),
    "packages": ['task', 'hr'],
    "payroll_wps_supported": true,
    "show_revenue": 0,
    "short_name": randomString(10),
    "request_items": [
      {
        "display_name": "Task",
        "name": "myportal_create_task",
        "sub_module": "myportal_create_task",
        "visibility": true,
      },
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
      },
      {
        "display_name": "Experience Certificate",
        "name": "experience_certificate_request",
        "sub_module": "payroll",
        "visibility": true
      },
      {
        "display_name": "Leave Encashment",
        "name": "leave_encashment",
        "sub_module": "leave_encashment",
        "visibility": true
      },
    ]
  };
}
//
// add more company info, emplpyee info, and request items to group dashboard?
// will it make the API slow? if yes, then how slow?
//
//
// oR!
//
// if we add financial summary to company - does it make sense? I think we can
//
//     for oowner - we need financial summary YES,
//
//
