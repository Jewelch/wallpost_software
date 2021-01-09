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

  //LeaveTypesPresenter.initWith(this.view, this.provider);

  Future<void> loadNextListOfLeaveTypes() async {
    if (provider.isLoading) return null;

    //_resetErrors();
    // view.reloadData();
    try {
      var leaveTypesList = await provider.getLeaveTypes();
      leaveTypes.addAll(leaveTypesList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  // int getNumberOfItems() {
  //   if (_hasErrors()) return _leaveTypes.length + 1;

  //   if (_leaveTypes.isEmpty) return 1;

  //   if (provider.didReachListEnd) {
  //     return _leaveTypes.length;
  //   } else {
  //     return _leaveTypes.length + 1;
  //   }
  // }

//MARK: Util functions
  // void reset() {
  //   provider.reset();
  //   _resetErrors();
  //   _leaveLists.clear();
  //   view.reloadData();
  // }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }

  bool isLoadingLeaveTypes() {
    return provider.isLoading;
  }
}
