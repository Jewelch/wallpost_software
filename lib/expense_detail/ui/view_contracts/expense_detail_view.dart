abstract class ExpenseDetailView {
  void showLoader();

  void onDidFailToLoadDetails();

  void onDidLoadDetails();

  void approve(String companyId, String expenseId);

  void reject(String companyId, String expenseId, String requestedBy);
}
