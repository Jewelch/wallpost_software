class Mocks {
  static var expenseCategoriesListResponse = [
    {
      "id": 1,
      "name": "Camp Expense",
      'subCatagories': [
        {"id": 1, "name": "Camp Expense", 'sub_categories': []}
      ],
      'projects': [],
      "disabled": false
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
      ],
    },
    {
      "id": 3,
      "name": "Camp Expense",
      'subCatagories': [
        {"id": 1, "name": "Camp Expense", 'sub_categories': []}
      ],
      'projects': [
        {"id": 1, "name": "Camp Expense", 'sub_categories': []},
      ],
      "disabled": true
    },
  ];
}
