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
        "company_id": 80,
        "company_name": "Aadidas",
        "notifications": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/80/DOC183964_nologo.jpg",
        "approval_count": 0,
        "approval_types": [],
        "financial_summary": {
          "currency": "MXN",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "0",
          "receivableOverdue": "0",
          "payableOverdue": "0",
          "profitLoss": "0",
          "profitLossPerc": "0"
        }
      },
      {
        "company_id": 46,
        "company_name": "Advisory LLC - test",
        "notifications": 5,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/46/DOC112471_CompanyLogo.png",
        "approval_count": 8,
        "approval_types": [
          {"count": 8, "type": "hr", "module_name": "leaveRequest"}
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
        "company_id": 83,
        "company_name": "Agro",
        "notifications": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/83/DOC184055_nologo.jpg",
        "approval_count": 0,
        "approval_types": [],
        "financial_summary": {
          "currency": "MXN",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "186.1K",
          "receivableOverdue": "0",
          "payableOverdue": "0",
          "profitLoss": "0",
          "profitLossPerc": "0"
        }
      },
      {
        "company_id": 44,
        "company_name": "Alpha Accounting Alone (test)",
        "notifications": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/44/DOC5438_nologo.jpg",
        "approval_count": 0,
        "approval_types": [],
        "financial_summary": {
          "currency": "USD",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "899.8K",
          "receivableOverdue": "1000",
          "payableOverdue": "0",
          "profitLoss": "0",
          "profitLossPerc": "0"
        }
      },
      {
        "company_id": 19,
        "company_name": "Amina_Georgia(test)",
        "notifications": 49,
        "company_logo":
            "https://s3.amazonaws.com/wallpostsoftware/120843/19/DOC125410_DOC107494_MicrosoftTeams-image (11).png",
        "approval_count": 35,
        "approval_types": [
          {"count": 35, "type": "hr", "module_name": "leaveRequest"}
        ],
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "1,628,790",
          "overall_revenue": 19012,
          "cashAvailability": "-1.1M",
          "receivableOverdue": "2M",
          "payableOverdue": "2.6M",
          "profitLoss": "869.8K",
          "profitLossPerc": "51.926309756913"
        }
      },
      {
        "company_id": 85,
        "company_name": "Aster Accounts",
        "notifications": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/85/DOC249788_nologo.jpg",
        "approval_count": 0,
        "approval_types": [],
        "financial_summary": {
          "currency": "EGP",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "0",
          "receivableOverdue": "0",
          "payableOverdue": "0",
          "profitLoss": "0",
          "profitLossPerc": "0"
        }
      },
      {
        "company_id": 2,
        "company_name": "B+Company (Test)",
        "notifications": 407,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/2/DOC4318_logo.jpg",
        "approval_count": 0,
        "approval_types": [],
        "financial_summary": {
          "currency": "AED",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": "-54M",
          "receivableOverdue": "36.4M",
          "payableOverdue": "983.2K",
          "profitLoss": "-50.8M",
          "profitLossPerc": "-47.5K"
        }
      },
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
      {"display_name": "Item Request", "name": "item_request", "sub_module": "item_request", "visibility": true},
      {
        "display_name": "Leave Encashment",
        "name": "leave_encashment",
        "sub_module": "leave_encashment",
        "visibility": true
      },
    ]
  };
}
