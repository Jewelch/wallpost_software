import 'package:wallpost/expense_requests/entities/expense_category.dart';

var expenseCategoriesListResponse = [
  {
    "id": 1,
    "name": "Camp Expense",
    'subCatagories': [
      {"id": 1, "name": "Camp Expense", 'sub_categories': []}
    ],
    'projects': []
  },
  {
    "id": 2,
    "name": "Employment Expense",
    'subCatagories': [],
    'projects': [
      {
        "id": 1,
        "name": "Camp Expense",
        'subCatagories': [
          {"id": 1, "name": "Camp Expense", 'sub_categories': []}
        ],
        'projects': []
      },
    ]
  },
  {
    "id": 3,
    "name": "Camp Expense",
    'subCatagories': [
      {"id": 1, "name": "Camp Expense", 'sub_categories': []}
    ],
    'projects': [
      {"id": 1, "name": "Camp Expense", 'sub_categories': []}
    ]
  },
];
var validExpenseCategoryMap = expenseCategoriesListResponse[0];

var unValidExpenseCategoryMap = <String, dynamic>{};

var mockExpenseCategories =
    expenseCategoriesListResponse.map((e) => ExpenseCategory.fromJson(e)).toList();
