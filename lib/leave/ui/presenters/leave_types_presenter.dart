// @dart=2.9

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_type.dart';
import 'package:wallpost/leave/services/leave_types_provider.dart';

abstract class LeaveTypeView {
  void reloadData();
}

class LeaveTypesPresenter {
  final LeaveTypeView view;
  final LeaveTypesProvider provider;
  List<LeaveType> leaveTypes = [];
  String _errorMessage;

  LeaveTypesPresenter(this.view) : provider = LeaveTypesProvider();


  Future<void> loadNextListOfLeaveTypes() async {
    if (provider.isLoading) return null;

    try {
      var leaveTypesList = await provider.getLeaveTypes();
      leaveTypes.addAll(leaveTypesList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }


  bool isLoadingLeaveTypes() {
    return provider.isLoading;
  }
}
