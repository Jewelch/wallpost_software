// @dart=2.9

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

import 'notification.dart';

class LeaveNotification extends Notification {
  String _applicantName;
  String _leaveType;
  DateTime _leaveFrom;
  DateTime _leaveTo;

  LeaveNotification.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var resourceInfoMap = sift.readMapFromMap(jsonMap, 'resourse_info');
      _applicantName = sift.readStringFromMap(resourceInfoMap, 'applicant');
      _leaveType = sift.readStringFromMap(resourceInfoMap, 'leaveTypeName');
      _leaveFrom = sift.readDateFromMap(resourceInfoMap, 'leaveFrom', 'yyyy-MM-dd');
      _leaveTo = sift.readDateFromMap(resourceInfoMap, 'leaveTo', 'yyyy-MM-dd');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast LeaveNotification response. Error message - ${e.errorMessage}');
    }
  }

  String get applicantName => _applicantName;

  String get leaveType => _leaveType;

  DateTime get leaveFrom => _leaveFrom;

  DateTime get leaveTo => _leaveTo;
}
