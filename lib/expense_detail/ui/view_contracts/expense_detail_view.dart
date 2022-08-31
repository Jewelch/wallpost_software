abstract class ExpenseDetailView {
  void showLoader();

  void onDidFailToLoadDetails();

  void onDidLoadDetails();

  void processApproval(String companyId, String expenseId, String requestedBy);

  void processRejection(String companyId, String expenseId, String requestedBy);
}
