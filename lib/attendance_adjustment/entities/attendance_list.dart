import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';

class AttendanceList extends JSONInitializable{
  late List<AttendanceListItem> attendanceList;

  AttendanceList.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap){
    try{
      var sift = Sift();
      var dataMap = sift.readMapListFromMap(jsonMap, "data");
      attendanceList = _attendanceListItems(dataMap);
    }on SiftException catch (e) {
      print(e.errorMessage);
      throw MappingException(
          'Failed to cast AttendanceListItem response. Error message - ${e.errorMessage}');
    }
  }

  _attendanceListItems(List<Map<String, dynamic>> dataMap) {

    List<AttendanceListItem> list = [];
    for (var jsonMap in dataMap) {
      try{
        var listItem = AttendanceListItem.fromJSon(jsonMap);
        list.add(listItem);
      } catch (e){}
    }
    return list;
  }


}