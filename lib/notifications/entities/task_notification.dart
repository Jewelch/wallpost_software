import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';

import 'notification.dart';

class TaskNotification extends Notification {
  String _taskName;
  String _status;
  String _createdBy;

  TaskNotification.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var resourceInfoMap = sift.readMapFromMap(jsonMap, 'resourse_info');
      _taskName = sift.readStringFromMap(resourceInfoMap, 'task_name');
      _status = sift.readStringFromMap(resourceInfoMap, 'status');
      _createdBy = sift.readStringFromMap(resourceInfoMap, 'created_by');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast TaskNotification response. Error message - ${e.errorMessage}');
    }
  }
  String get taskName => _taskName;

  String get status => _status;

  String get createdBy => _createdBy;


}
