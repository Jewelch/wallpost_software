import 'dart:ui';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/leave/leave_detail/entities/leave_detail.dart';
import 'package:wallpost/leave/leave_detail/services/leave_detail_provider.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../view_contracts/leave_detail_view.dart';

class LeaveDetailPresenter {
  final String _companyId;
  final String _leaveId;
  final bool _didComeToDetailScreenFromApprovalList;
  final LeaveDetailView _view;
  final LeaveDetailProvider _leaveDetailProvider;
  late LeaveDetail _leaveDetail;
  String? _errorMessage;
  var _didProcessApprovalOrRejection = false;

  LeaveDetailPresenter(
    this._companyId,
    this._leaveId,
    this._view, {
    bool didComeToDetailScreenFromApprovalList = false,
  })  : this._didComeToDetailScreenFromApprovalList = didComeToDetailScreenFromApprovalList,
        _leaveDetailProvider = LeaveDetailProvider(_companyId);

  LeaveDetailPresenter.initWith(
    this._companyId,
    this._leaveId,
    this._view,
    this._leaveDetailProvider, {
    bool didComeToDetailScreenFromApprovalList = false,
  }) : this._didComeToDetailScreenFromApprovalList = didComeToDetailScreenFromApprovalList;

  Future<void> loadDetail() async {
    if (_leaveDetailProvider.isLoading) return;

    _errorMessage = null;
    _view.showLoader();
    try {
      _leaveDetail = await _leaveDetailProvider.get(_leaveId);
      _view.onDidLoadDetails();
    } on WPException catch (e) {
      _errorMessage = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadDetails();
    }
  }

  //MARK: Functions for approval and rejection

  void initiateApproval() {
    _view.processApproval(_companyId, _leaveId, _leaveDetail.applicantName);
  }

  void initiateRejection() {
    _view.processRejection(_companyId, _leaveId, _leaveDetail.applicantName);
  }

  Future<void> onDidProcessApprovalOrRejection(dynamic didProcess) async {
    if (didProcess == true) {
      _didProcessApprovalOrRejection = true;
      await loadDetail();
    }
  }

  //MARK: Getters

  bool shouldShowApprovalActions() {
    return _didComeToDetailScreenFromApprovalList && _leaveDetail.isPendingApproval();
  }

  String getTitle() {
    return _leaveDetail.applicantName;
  }

  String getLeaveType() {
    return _leaveDetail.leaveType;
  }

  String getLeaveStartDate() {
    return _leaveDetail.startDate.toReadableString();
  }

  String getLeaveEndDate() {
    return _leaveDetail.endDate.toReadableString();
  }

  String getTotalDays() {
    return "${_leaveDetail.totalLeaveDays}";
  }

  String getTotalPaidDays() {
    return "${_leaveDetail.paidDays}";
  }

  String getTotalUnpaidDays() {
    return "${_leaveDetail.unPaidDays}";
  }

  String getLeaveReason() {
    return _leaveDetail.leaveReason;
  }

  String? getAttachmentUrl() {
    return _leaveDetail.attachmentUrl;
  }

  String? getStatus() {
    if (_leaveDetail.isApproved()) return null;

    if (_leaveDetail.isPendingApproval()) {
      var status = _leaveDetail.statusString;
      if (_leaveDetail.pendingWithUsers != null)
        return "$status with ${_leaveDetail.pendingWithUsers}";
      else
        return status;
    }

    return _leaveDetail.statusString;
  }

  Color getStatusColor() {
    if (_leaveDetail.isPendingApproval()) {
      return AppColors.yellow;
    } else
      return AppColors.red;
  }

  String? get errorMessage => _errorMessage;

  get didProcessApprovalOrRejection => _didProcessApprovalOrRejection;
}
