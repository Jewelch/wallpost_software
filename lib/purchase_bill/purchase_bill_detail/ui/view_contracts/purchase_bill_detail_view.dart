abstract class PurchaseBillDetailView {
  void showLoader();

  void onDidFailToLoadDetails();

  void onDidLoadDetails();

  void processApproval(String companyId, String billId, String billTo);

  void processRejection(String companyId, String billId, String billTo);
}
