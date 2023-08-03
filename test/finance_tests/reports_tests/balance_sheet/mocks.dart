class Mocks {
  static Map<String, dynamic> balanceSheetReportResponse = {
    "Assets": {
      "id": 5,
      "name": "Equity",
      "parent_id": null,
      "group_name": "",
      "level": 0,
      "amount": "2,000,600",
      "group": true,
      "childrens": [
        {
          "id": 63,
          "name": "Stockholders Equity",
          "parent_id": 5,
          "group_name": "",
          "level": 1,
          "amount": "2,000,600",
          "group": true,
          "childrens": [
            {
              "id": 80,
              "name": "Paid-In Capital",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "1,807,062",
              "group": true,
              "childrens": [
                {
                  "id": "led54",
                  "name": "Opening Equity (Control A/C)",
                  "code": "",
                  "parent_id": 80,
                  "group_name": "Paid-In Capital",
                  "amount": "1,807,062",
                  "group": false
                }
              ]
            },
            {
              "id": 81,
              "name": "Retained Earnings",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "193,538",
              "group": true,
              "childrens": [
                {
                  "id": "led55",
                  "name": "Retained Earning",
                  "code": "",
                  "parent_id": 81,
                  "group_name": "Retained Earnings",
                  "amount": "193,538",
                  "group": false
                }
              ]
            }
          ]
        }
      ]
    },
    "Liabilities": {
      "id": 5,
      "name": "Equity",
      "parent_id": null,
      "group_name": "",
      "level": 0,
      "amount": "2,000,600",
      "group": true,
      "childrens": [
        {
          "id": 63,
          "name": "Stockholders Equity",
          "parent_id": 5,
          "group_name": "",
          "level": 1,
          "amount": "2,000,600",
          "group": true,
          "childrens": [
            {
              "id": 80,
              "name": "Paid-In Capital",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "1,807,062",
              "group": true,
              "childrens": [
                {
                  "id": "led54",
                  "name": "Opening Equity (Control A/C)",
                  "code": "",
                  "parent_id": 80,
                  "group_name": "Paid-In Capital",
                  "amount": "1,807,062",
                  "group": false
                }
              ]
            },
            {
              "id": 81,
              "name": "Retained Earnings",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "193,538",
              "group": true,
              "childrens": [
                {
                  "id": "led55",
                  "name": "Retained Earning",
                  "code": "",
                  "parent_id": 81,
                  "group_name": "Retained Earnings",
                  "amount": "193,538",
                  "group": false
                }
              ]
            }
          ]
        }
      ]
    },
    "Equity": {
      "id": 5,
      "name": "Equity",
      "parent_id": null,
      "group_name": "",
      "level": 0,
      "amount": "2,000,600",
      "group": true,
      "childrens": [
        {
          "id": 63,
          "name": "Stockholders Equity",
          "parent_id": 5,
          "group_name": "",
          "level": 1,
          "amount": "2,000,600",
          "group": true,
          "childrens": [
            {
              "id": 80,
              "name": "Paid-In Capital",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "1,807,062",
              "group": true,
              "childrens": [
                {
                  "id": "led54",
                  "name": "Opening Equity (Control A/C)",
                  "code": "",
                  "parent_id": 80,
                  "group_name": "Paid-In Capital",
                  "amount": "1,807,062",
                  "group": false
                }
              ]
            },
            {
              "id": 81,
              "name": "Retained Earnings",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "193,538",
              "group": true,
              "childrens": [
                {
                  "id": "led55",
                  "name": "Retained Earning",
                  "code": "",
                  "parent_id": 81,
                  "group_name": "Retained Earnings",
                  "amount": "193,538",
                  "group": false
                }
              ]
            }
          ]
        }
      ]
    },
    "Total Assets": {"name": "Total Assets", "amount": "30,817,529", "_amount": 30817529.459999997},
    "Total Liability and Owners Equity": {
      "name": "Total Liability and Owners Equity",
      "amount": "42,649,921",
      "_amount": 42649920.699000016
    },
    "Profit & Loss Account": {"name": "Profit & Loss Account", "amount": "-11,830,391"},
    "Difference": {"name": "Difference", "amount": "-2,000"}
  };
}
