import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

import 'notification.dart';

class LeaveNotification extends Notification {
  late String _applicantName;
  late String _leaveType;
  late DateTime _leaveFrom;
  late DateTime _leaveTo;

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
