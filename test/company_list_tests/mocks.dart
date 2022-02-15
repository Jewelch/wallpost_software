import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> companiesListResponse = {
    "groups": [
      {
        "group_id": 0,
        "name": "Group Summary",
        "default_currency": "USD",
        "is_default": 0,
        "group_companies": ["2", " 6", " 3", " 7", " 5", " 4", " 1"],
        "group_summary": {
          "cashAvailability": 617100.12,
          "receivableOverdue": 2117666.3144,
          "payableOverdue": 644238.1764000001,
          "profitLoss": 0
        }
      },
      {
        "group_id": 1,
        "name": "Partial Company",
        "default_currency": "USD",
        "is_default": 0,
        "group_companies": ["5", "6"],
        "group_summary": {
          "cashAvailability": 0,
          "receivableOverdue": 444.08000000000004,
          "payableOverdue": 0,
          "profitLoss": 0
        }
      },
      {
        "group_id": 2,
        "name": "Test Group",
        "default_currency": "USD",
        "is_default": 1,
        "group_companies": ["2", "3", "5"],
        "group_summary": {
          "cashAvailability": 362300.12,
          "receivableOverdue": 2090755.7944,
          "payableOverdue": 644165.3764000001,
          "profitLoss": 0
        }
      }
    ],
    "companies": [
      {
        "company_id": 2,
        "company_name": "B+Company (Test)",
        "notifications": 84,
        "approval_count": 16,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/2/DOC328_logo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 99533,
          "receivableOverdue": 574261.46,
          "payableOverdue": 176968.51,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      },
      {
        "company_id": 6,
        "company_name": "Construction- & Co",
        "notifications": 0,
        "approval_count": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/6/DOC371_nologo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 0,
          "receivableOverdue": 0,
          "payableOverdue": 0,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      },
      {
        "company_id": 3,
        "company_name": "Construction-Company (Test)",
        "notifications": 0,
        "approval_count": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/3/DOC15_nologo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 0,
          "receivableOverdue": 0,
          "payableOverdue": 0,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      },
      {
        "company_id": 7,
        "company_name": "Contracting Co (Test)",
        "notifications": 0,
        "approval_count": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/7/DOC78_nologo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 0,
          "receivableOverdue": 0,
          "payableOverdue": 0,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      },
      {
        "company_id": 5,
        "company_name": "Ne Company[Test]",
        "notifications": 0,
        "approval_count": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/5/DOC368_nologo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 0,
          "receivableOverdue": 122,
          "payableOverdue": 0,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      },
      {
        "company_id": 4,
        "company_name": "Real Estate[Test]",
        "notifications": 0,
        "approval_count": 0,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/4/DOC15_nologo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 0,
          "receivableOverdue": 0,
          "payableOverdue": 0,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      },
      {
        "company_id": 1,
        "company_name": "Test-company[Advisory]",
        "notifications": 36,
        "approval_count": 20,
        "company_logo": "https://s3.amazonaws.com/wallpostsoftware/120843/1/DOC1_nologo.jpg",
        "financial_summary": {
          "currency": "QAR",
          "actual_revenue_display": "0",
          "overall_revenue": 0,
          "cashAvailability": 70000,
          "receivableOverdue": 7393,
          "payableOverdue": 20,
          "profitLoss": 0,
          "profitLossPerc": 0
        }
      }
    ]
  };

  static Map<String, dynamic> companyDetailsResponse = {
    "absolute_upload_path": randomString(10),
    "account_no": randomBetween(1000, 5000),
    "commercial_name": randomString(10),
    "company_id": randomBetween(1000, 5000),
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
  };
}
