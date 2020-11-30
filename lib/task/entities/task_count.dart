import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class TaskCount extends JSONInitializable {
  num _overdue;
  num _dueToday;
  num _dueInAWeek;
  num _upcomingDue;
  num _completed;
  num _all;

  TaskCount.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _overdue = sift.readNumberFromMap(jsonMap, 'overdue');
      _dueToday = sift.readNumberFromMap(jsonMap, 'due_today');
      _dueInAWeek = sift.readNumberFromMap(jsonMap, 'due_in_week');
      _upcomingDue = sift.readNumberFromMap(jsonMap, 'up_comming_dues');
      _completed = sift.readNumberFromMap(jsonMap, 'completed');
      _all = sift.readNumberFromMap(jsonMap, 'all');
    } on SiftException catch (e) {
      throw MappingException('Failed to cast TaskCount response. Error message - ${e.errorMessage}');
    }
  }

  num get overdue => _overdue;

  num get dueToday => _dueToday;

  num get dueInAWeek => _dueInAWeek;

  num get upcomingDue => _upcomingDue;

  num get completed => _completed;

  num get all => _all;
}
