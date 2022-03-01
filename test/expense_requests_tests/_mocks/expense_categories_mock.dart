var expenseCategoriesListResponse = [
  {"id": 1, "name": "Camp Expense", 'sub_categories': [], 'projects': []},
  {"id": 2, "name": "Employment Expense", 'sub_categories': [], 'projects': []},
];

var validExpenseCategoryMap = expenseCategoriesListResponse[0];
var unValidExpenseCategoryMap = <String, dynamic>{};

var successFullAddingExpenseRequestResponse = {
  "status": "success",
  "data": {"id": "24", "status": "success", "message": "Approval Sent."}
};
