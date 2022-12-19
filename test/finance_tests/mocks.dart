class Mocks {
  static Map<String, dynamic> financialDashboardResponse = {
    "profit_and_loss": "-5,991,721,466",
    "income": "8,410,392",
    "expenses": "3,736,625",
    "bank_and_cashe": "-123,427,924,745,639",
    "cashe_in": "34,940",
    "cashe_out": "123,387,989,914,483",
    "chart_data": {
      "months": ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"],
      "cache_in": ["5,000", "7,837", "18,603", "3,500", "0", "0", "0", "0", "0", "0", "0", "0"],
      "cache_out": ["0", "12,859", "123,387,989,900,536", "0", "0", "0", "0", "0", "0", "1,088", "0", "0"]
    },
    "invoice_report": {
      "overdue": "558,204,588",
      "currrent_due": "10,090",
      "invoiced": "562,157,535",
      "collected": "525,433"
    },
    "bill_report": {
      "overdue": "124,662,473,536",
      "current_due": "10,090",
      "billed": "164,663,328,151",
      "paid": "40,000,905,076"
    }

    // "groups": [
    //   {
    //     "group_id": 0,
    //     "name": "Group Summary",
    //     "default_currency": "USD",
    //     "is_default": 0,
    //     "group_companies": [
    //       "80",
    //       " 46",
    //       " 83",
    //       " 44",
    //       " 19",
    //       " 85",
    //       " 2",
    //       " 59",
    //     ],
    //     "group_summary": {
    //       "cashAvailability": "-17.6M",
    //       "receivableOverdue": "25B",
    //       "payableOverdue": "1.7M",
    //       "profitLoss": "-623.5M"
    //     }
    //   },
    //   {
    //     "group_id": 1,
    //     "name": "Partial Company",
    //     "default_currency": "USD",
    //     "is_default": 0,
    //     "group_companies": [
    //       "5",
    //       "44",
    //       "45",
    //       "59",
    //       "43",
    //     ],
    //     "group_summary": {
    //       "cashAvailability": "868.2K",
    //       "receivableOverdue": "2M",
    //       "payableOverdue": "235.4K",
    //       "profitLoss": "1.3M"
    //     }
    //   },
    //   {
    //     "group_id": 2,
    //     "name": "Manufacturing & Retail",
    //     "default_currency": "USD",
    //     "is_default": 1,
    //     "group_companies": [
    //       "2",
    //       "14",
    //       "15",
    //       "40",
    //       "19",
    //       "60",
    //       "63",
    //       "64",
    //       "76",
    //     ],
    //     "group_summary": {
    //       "cashAvailability": "-14.9M",
    //       "receivableOverdue": "10.4M",
    //       "payableOverdue": "1.1M",
    //       "profitLoss": "-13.6M"
    //     }
    //   },
    // ],
    // "companies": [
    //   {
    //     "companyApprovalCount": 8,
    //     "company_info": {
    //       "company_id": 13,
    //       "account_no": 123123,
    //       "company_name": "Smart Management - Qatar",
    //       "short_name": "Smart Management - Qatar",
    //       "commercial_name": "Smart Management - Qatar",
    //       "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
    //       "js_date_format": "yyyy-mm-dd",
    //       "currency": "USD",
    //       "packages": ["hr", "task", "timesheet"],
    //       "is_trial": true,
    //     },
    //     "employee": {
    //       "employment_id": "gEBrqqLflxXRNQT",
    //       "name": "Obaid Mohamed",
    //       "designation": "IOS Developer",
    //       "email_id_office": "mahmed@wallpostsoftware.com",
    //       "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
    //       "employment_id_v1": 2123,
    //       "line_manager": "Ishaque Sethikunhi Ameen",
    //       "Roles": ["task_line_manager"],
    //     },
    //     "request_items": [
    //       {
    //         "display_name": "Disciplinary Action",
    //         "name": "disciplinary_request",
    //         "sub_module": "disciplinary_action",
    //         "visibility": true
    //       },
    //       {
    //         "display_name": "Employment Certificate",
    //         "name": "time_off_request",
    //         "sub_module": "time_off",
    //         "visibility": true
    //       },
    //       {
    //         "display_name": "Expense Request",
    //         "name": "expense_request",
    //         "sub_module": "expense_request",
    //         "visibility": true
    //       }
    //     ],
    //     "financial_summary": {
    //       "currency": "BGN",
    //       "actual_revenue_display": "0",
    //       "overall_revenue": 0,
    //       "cashAvailability": "9.9M",
    //       "receivableOverdue": "32.3K",
    //       "payableOverdue": "67.3K",
    //       "profitLoss": "14.7K",
    //       "profitLossPerc": "51.854325587935"
    //     }
    //   },
    //   {
    //     "companyApprovalCount": 8,
    //     "company_info": {
    //       "company_id": 13,
    //       "account_no": 123123,
    //       "company_name": "Smart Management - Qatar",
    //       "short_name": "Smart Management - Qatar",
    //       "commercial_name": "Smart Management - Qatar",
    //       "company_logo": "https://s3.amazonaws.com/wallpostsoftware/123123/13/DOC71284_SMIT Logo.PNG",
    //       "js_date_format": "yyyy-mm-dd",
    //       "currency": "USD",
    //       "packages": ["hr", "task", "timesheet"],
    //       "is_trial": true,
    //     },
    //     "employee": {
    //       "employment_id": "gEBrqqLflxXRNQT",
    //       "name": "Obaid Mohamed",
    //       "designation": "IOS Developer",
    //       "email_id_office": "mahmed@wallpostsoftware.com",
    //       "image": "DOC_3e1be345-9506-4a8e-a66e-9b214200e691.png",
    //       "employment_id_v1": 2123,
    //       "line_manager": "Ishaque Sethikunhi Ameen",
    //       "Roles": ["task_line_manager"],
    //     },
    //     "request_items": [
    //       {
    //         "display_name": "Disciplinary Action",
    //         "name": "disciplinary_request",
    //         "sub_module": "disciplinary_action",
    //         "visibility": true
    //       },
    //       {
    //         "display_name": "Employment Certificate",
    //         "name": "time_off_request",
    //         "sub_module": "time_off",
    //         "visibility": true
    //       },
    //       {
    //         "display_name": "Expense Request",
    //         "name": "expense_request",
    //         "sub_module": "expense_request",
    //         "visibility": true
    //       }
    //     ],
    //     "financial_summary": null,
    //   }
    // ]
  };
}
