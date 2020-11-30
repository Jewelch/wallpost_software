import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class Break extends JSONInitializable {
  String _id;
  DateTime _startTime;
  DateTime _endTime;

  Break.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _id = sift.readStringFromMap(jsonMap, 'interval_id');
      _startTime = sift.readDateFromMap(jsonMap, 'actual_break_in', 'yyyy-MM-dd HH:mm:ss');
      _endTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'actual_break_out', 'yyyy-MM-dd HH:mm:ss', null);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Break response. Error message - ${e.errorMessage}');
    }
  }

  String get id => _id;

  DateTime get startTime => _startTime;

  DateTime get endTime => _endTime;

  bool isActive() {
    return _startTime != null && _endTime == null;
  }
}
