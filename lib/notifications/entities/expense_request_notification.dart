import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

import 'notification.dart';

class ExpenseRequestNotification extends Notification {
  String _applicantName;
  String _amount;

  ExpenseRequestNotification.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var resourceInfoMap = sift.readMapFromMap(jsonMap, 'resourse_info');
      _applicantName = sift.readStringFromMap(resourceInfoMap, 'applicant');
      _amount = sift.readStringFromMap(resourceInfoMap, 'amount');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast ExpenseRequestNotification response. Error message - ${e.errorMessage}');
    }
  }

  String get applicantName => _applicantName;

  String get amount => _amount;
}
