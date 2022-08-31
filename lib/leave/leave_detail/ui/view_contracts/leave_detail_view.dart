abstract class LeaveDetailView {
  void showLoader();

  void onDidFailToLoadDetails();

  void onDidLoadDetails();

  void processApproval(String companyId, String leaveId, String applicantName);

  void processRejection(String companyId, String leaveId, String applicantName);
}
