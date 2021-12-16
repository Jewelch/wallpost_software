// @dart=2.9

import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class PunchInNowPermission extends JSONInitializable {
  bool _canPunchInNow;
  num _secondsTillPunchIn;

  PunchInNowPermission.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      _canPunchInNow = sift.readBooleanFromMap(jsonMap, 'status');
      _secondsTillPunchIn = sift.readNumberFromMapWithDefaultValue(jsonMap, 'remaining_in_min', 0);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast PunchInNowPermission response. Error message - ${e.errorMessage}');
    }
  }

  bool get canPunchInNow => _canPunchInNow;

  num get secondsTillPunchIn => _secondsTillPunchIn;


/*String get timeTillPunchIn {
    int aMinuteInSeconds = 60;
    int anHourInSeconds = 3600;
    int aDayInSeconds = 86400;

    int remainingDuration = _secondsTillPunchIn;

    int elapsedDays = remainingDuration ~/ aDayInSeconds;
    remainingDuration = remainingDuration % aDayInSeconds;

    int elapsedHours = remainingDuration ~/ anHourInSeconds;
    remainingDuration = remainingDuration % anHourInSeconds;

    int elapsedMinutes = remainingDuration ~/ aMinuteInSeconds;
    remainingDuration = remainingDuration % aMinuteInSeconds;

    int elapsedSeconds = remainingDuration;

    if (elapsedDays > 0) {
      return elapsedDays > 1 ? '$elapsedDays days' : '$elapsedDays day';
    } else {
      var hourPart = '';
      var minPart = '';
      var secPart = '';
      if (elapsedHours > 0) hourPart = '${elapsedHours}h ';
      if (elapsedMinutes > 0) minPart = '${elapsedMinutes}m ';
      if (elapsedSeconds >= 0) secPart = '${elapsedSeconds}s';

      return '$hourPart$minPart$secPart';
    }
  }*/
}
