import '../../_shared/exceptions/mapping_exception.dart';

enum LeaveApprovalStatus {
  all,
  pendingApproval,
  approved,
  rejected;

  static LeaveApprovalStatus initFromString(String status) {
    if (status == 'approved') return LeaveApprovalStatus.approved;
    if (status == 'pending') return LeaveApprovalStatus.pendingApproval;
    if (status == 'rejected') return LeaveApprovalStatus.rejected;
    throw MappingException("Failed to cast LeaveApprovalStatus");
  }
}

extension LeaveStatusExtension on LeaveApprovalStatus {
  String stringValue() {
    if (this == LeaveApprovalStatus.pendingApproval) {
      return 'pending';
    } else if (this == LeaveApprovalStatus.approved) {
      return 'approved';
    } else {
      return 'rejected';
    }
  }
}
