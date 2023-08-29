class Mocks {
  static List<Map<String, dynamic>> balanceSheetReportResponse = [
    {
      "id": 2,
      "name": "Passifs OK ",
      "parent_id": null,
      "group_name": "",
      "level": 0,
      "amount": "515,825,792",
      "group": true,
      "childrens": [
        {
          "id": 64,
          "name": "Passifs Non Courants PEOBLEM ENGLISH NAME ",
          "parent_id": 2,
          "group_name": "",
          "level": 1,
          "amount": "2,900",
          "group": true,
          "childrens": [
            {
              "id": 84,
              "name": "Dettes à long terme ",
              "parent_id": 64,
              "group_name": "",
              "level": 2,
              "amount": "19,100",
              "group": true,
              "childrens": [
                {
                  "id": "led69",
                  "name": "Loans ",
                  "code": "",
                  "parent_id": 84,
                  "group_name": "Long-Term Debts",
                  "amount": "19,000",
                  "group": false
                },
                {
                  "id": "led1457",
                  "name": "ABC test ",
                  "code": "",
                  "parent_id": 84,
                  "group_name": "Long-Term Debts",
                  "amount": "100",
                  "group": false
                }
              ]
            },
            {
              "id": 87,
              "name": "Éventualités et dispositions ",
              "parent_id": 64,
              "group_name": "",
              "level": 2,
              "amount": "-16,200",
              "group": true,
              "childrens": [
                {
                  "id": "led73",
                  "name": "Provisions ",
                  "code": "",
                  "parent_id": 87,
                  "group_name": "Contingencies And Provisions",
                  "amount": "-16,200",
                  "group": false
                }
              ]
            }
          ]
        },
        {
          "id": 65,
          "name": "Passifs Courants PROBLEM ENGLISH NAME ",
          "parent_id": 2,
          "group_name": "",
          "level": 1,
          "amount": "515,942,892",
          "group": true,
          "childrens": [
            {
              "id": -2,
              "name": "Autres passifs courants ",
              "parent_id": 65,
              "group_name": "",
              "level": 2,
              "amount": "511,290,099",
              "group": true,
              "childrens": [
                {
                  "id": -4,
                  "name": "Employés ",
                  "parent_id": -2,
                  "group_name": "Accounts & Other Payables",
                  "level": 3,
                  "amount": "53,843,014",
                  "group": true,
                  "childrens": [
                    {
                      "id": "led4499",
                      "name": "Marta Smith[SM001] ",
                      "code": null,
                      "parent_id": -4,
                      "group_name": "Employees",
                      "amount": "2,774",
                      "group": false
                    }
                  ]
                },
                {
                  "id": 88,
                  "name": "Fournisseurs ",
                  "parent_id": -2,
                  "group_name": "Accounts & Other Payables",
                  "level": 3,
                  "amount": "1,533,600",
                  "group": true,
                  "childrens": [
                    {
                      "id": "led280",
                      "name": "Unitech Qatar ",
                      "code": null,
                      "parent_id": 88,
                      "group_name": "Suppliers",
                      "amount": "630,584",
                      "group": false
                    },
                    {
                      "id": "led281",
                      "name": "Rusiya Group - Najma Branch ",
                      "code": null,
                      "parent_id": 88,
                      "group_name": "Suppliers",
                      "amount": "-451,673",
                      "group": false
                    }
                  ]
                },
                {
                  "id": 89,
                  "name": "Autres charges d'exploitation ",
                  "parent_id": -2,
                  "group_name": "",
                  "level": 3,
                  "amount": "455,868,782",
                  "group": true,
                  "childrens": [
                    {
                      "id": "led1022",
                      "name": "Product mobile ",
                      "code": "",
                      "parent_id": 89,
                      "group_name": "Other Payables",
                      "amount": "200",
                      "group": false
                    },
                    {
                      "id": "led1023",
                      "name": "Product sales ",
                      "code": "",
                      "parent_id": 89,
                      "group_name": "Other Payables",
                      "amount": "455,598,582",
                      "group": false
                    },
                    {
                      "id": "led1578",
                      "name": "Advisory Payable  ",
                      "code": "",
                      "parent_id": 89,
                      "group_name": "Other Payables",
                      "amount": "270,000",
                      "group": false
                    }
                  ]
                },
                {
                  "id": 91,
                  "name": "Passifs accumulés et différés ",
                  "parent_id": -2,
                  "group_name": "",
                  "level": 3,
                  "amount": "-136,933",
                  "group": true,
                  "childrens": [
                    {
                      "id": "led79",
                      "name": "Accrued Liabilities ",
                      "code": "",
                      "parent_id": 91,
                      "group_name": "Accrued And Deferred Liabilities",
                      "amount": "-136,933",
                      "group": false
                    }
                  ]
                },
                {
                  "id": "led12",
                  "name": "Unpaid Expense Claims ",
                  "code": "",
                  "parent_id": -2,
                  "group_name": "Accounts & Other Payables",
                  "amount": "181,636",
                  "group": false
                }
              ]
            },
            {
              "id": "led2221",
              "name": "Input SGST ",
              "code": null,
              "parent_id": 65,
              "group_name": "Current Liabilities",
              "amount": "-14,540",
              "group": false
            },
            {
              "id": "led2222",
              "name": "Output SGST ",
              "code": null,
              "parent_id": 65,
              "group_name": "Current Liabilities",
              "amount": "1,901",
              "group": false
            }
          ]
        },
        {
          "id": 608,
          "name": "Rent  ",
          "parent_id": 2,
          "group_name": "",
          "level": 1,
          "amount": "-110,000",
          "group": true,
          "childrens": [
            {
              "id": "led1202",
              "name": "Rent payables ",
              "code": "",
              "parent_id": 608,
              "group_name": "Rent ",
              "amount": "-110,000",
              "group": false
            }
          ]
        },
        {
          "id": 669,
          "name": "Current Liablities CA103",
          "parent_id": 2,
          "group_name": "",
          "level": null,
          "amount": "-10,000",
          "group": true,
          "childrens": [
            {
              "id": "led4513",
              "name": "Cash 123456",
              "code": "123456",
              "parent_id": 669,
              "group_name": "Current Liablities",
              "amount": "-10,000",
              "group": false
            }
          ]
        }
      ]
    },
    {
      "id": 5,
      "name": "Capitaux Propres ",
      "parent_id": null,
      "group_name": "",
      "level": 0,
      "amount": "930,610,800",
      "group": true,
      "childrens": [
        {
          "id": 63,
          "name": "Capital Social ",
          "parent_id": 5,
          "group_name": "",
          "level": 1,
          "amount": "930,610,800",
          "group": true,
          "childrens": [
            {
              "id": 80,
              "name": "Capital social ",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "1,148,098,749",
              "group": true,
              "childrens": [
                {
                  "id": "led52",
                  "name": "Additional Paid-In Capital ",
                  "code": "",
                  "parent_id": 80,
                  "group_name": "Paid-In Capital",
                  "amount": "1,000",
                  "group": false
                },
                {
                  "id": "led53",
                  "name": "Legal Equity (Statutory Capital) ",
                  "code": "",
                  "parent_id": 80,
                  "group_name": "Paid-In Capital",
                  "amount": "1,216,600",
                  "group": false
                },
                {
                  "id": "led54",
                  "name": "Opening Equity (Control A/C) ",
                  "code": "",
                  "parent_id": 80,
                  "group_name": "Paid-In Capital",
                  "amount": "1,146,881,149",
                  "group": false
                }
              ]
            },
            {
              "id": 81,
              "name": "Résultats reportés PROBLEM ENGLISH NAME ",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "-217,537,949",
              "group": true,
              "childrens": [
                {
                  "id": "led55",
                  "name": "Retained Earning ",
                  "code": "",
                  "parent_id": 81,
                  "group_name": "Retained Earnings",
                  "amount": "-218,771,949",
                  "group": false
                },
                {
                  "id": "led56",
                  "name": "Net Income ",
                  "code": "",
                  "parent_id": 81,
                  "group_name": "Retained Earnings",
                  "amount": "1,234,000",
                  "group": false
                }
              ]
            },
            {
              "id": 83,
              "name": "Autres éléments de capitaux propres ",
              "parent_id": 63,
              "group_name": "",
              "level": 2,
              "amount": "50,000",
              "group": true,
              "childrens": [
                {
                  "id": "led65",
                  "name": "Other Additional Capital ",
                  "code": "",
                  "parent_id": 83,
                  "group_name": "Other Equity Items",
                  "amount": "50,000",
                  "group": false
                }
              ]
            }
          ]
        }
      ]
    },
    {"name": "Total Assets", "amount": "1,373,710,969", "_amount": 1373710969.4665},
    {"name": "Total Liability and Owners Equity", "amount": "1,446,436,592", "_amount": 1446436591.7093},
    {"name": "Profit & Loss Account", "amount": "-72,460,609"},
    {"name": "Difference", "amount": "-265,013"}
  ];
}
