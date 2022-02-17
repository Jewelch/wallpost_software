import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';

class LeaveEmployee extends JSONInitializable {
  late num _v1Id;
  late String _v2Id;
  late String _userId;
  late String _fullName;
  late String _profileImageUrl;
  late String _emailId;

  LeaveEmployee.fromJson(Map<String, dynamic> jsonMap)
      : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var employmentDetailsMap =
          sift.readMapFromMap(jsonMap, 'employment_details');
      _v1Id = sift.readNumberFromMap(jsonMap, 'id');
      _v2Id = sift.readStringFromMap(jsonMap, 'employment_id');
      _userId = sift.readStringFromMap(jsonMap, 'user_master_id');
      _fullName = sift.readStringFromMap(employmentDetailsMap, 'fullName');
      _profileImageUrl = sift.readStringFromMap(jsonMap, 'profile_image');
      _emailId = sift.readStringFromMap(jsonMap, 'email_id_office');
    } on SiftException catch (e) {
      throw MappingException(
          'Failed to cast TaskAssignee response. Error message - ${e.errorMessage}');
    }
  }

  num get v1Id => _v1Id;

  String get v2Id => _v2Id;

  String get userId => _userId;

  String get fullName => _fullName;

  String get profileImageUrl => _profileImageUrl;

  String get emailId => _emailId;
}
