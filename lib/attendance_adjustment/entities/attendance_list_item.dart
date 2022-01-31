import 'package:intl/intl.dart';
import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class AttendanceListItem extends JSONInitializable {
  late DateTime _date;
  late DateTime? _punchInTime;
  late DateTime? _punchOutTime;
  late String? _status;

  AttendanceListItem.fromJSon(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    try {
      var sift = Sift();
      _date = sift.readDateFromMap(jsonMap, 'date', 'yyyy-MM-dd');
      _punchInTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'punch_in_time', 'HH:mm', null);
      _punchOutTime = sift.readDateFromMapWithDefaultValue(jsonMap, 'punch_out_time', 'HH:mm', null);
      _status = sift.readStringFromMapWithDefaultValue(jsonMap, 'adjusted_status', null);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AttendanceListItem response. Error message - ${e.errorMessage}');
    }
  }

  String get date => _convertDateToString(_date);

  String get punchInTime => _convertTimeToString(_punchInTime);

  String get punchOutTime => _convertTimeToString(_punchOutTime);

  String? get status => _status;

  String _convertTimeToString(DateTime? time) {
    if (time == null) return '';
    return DateFormat('hh:mm').format(time);
  }

  String _convertDateToString(DateTime? time) {
    if (time == null) return '';
    return DateFormat('yyyy-MM-dd').format(time);
  }
}
