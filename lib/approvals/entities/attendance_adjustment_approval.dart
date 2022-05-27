import 'package:dio/dio.dart';
import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/approvals/entities/approval.dart';

import '../../_shared/exceptions/mapping_exception.dart';

class AttendanceAdjustmentApproval implements JSONInitializable{
  late num _id;
  late num _companyId;
  late String _attendanceId;
  late num _empId;
  late String _name;
  late String _date;
  late String? _punchIn;
  late String? _punchOut;
  late String? _workStatus;
  late String? _adjustedPunchIn;
  late String _adjustedPunchOut;
  late String _adjustedStatus;
  late String _reason;


  AttendanceAdjustmentApproval.fromJson(Map<String, dynamic> jsonMap){

    try{
      var sift = Sift();
      var detailsMap = sift.readMapFromMap(jsonMap, "details");

      _attendanceId = sift.readStringFromMap(detailsMap, 'attendance_id');
      _empId = sift.readNumberFromMap(detailsMap, 'emp_id') ;
      _name =sift.readStringFromMap(detailsMap, 'name') ;
      _date = sift.readStringFromMap(detailsMap, 'date');
      _punchIn =sift.readStringFromMapWithDefaultValue(detailsMap, 'punch_in',null);
      _punchOut = sift.readStringFromMapWithDefaultValue(detailsMap, 'punch_out');
      _workStatus =sift.readStringFromMapWithDefaultValue(detailsMap, 'work_status',null) ;
      _adjustedPunchIn = sift.readStringFromMapWithDefaultValue(detailsMap, 'adjusted_punchin',null);
      _adjustedPunchOut =sift.readStringFromMap(detailsMap, 'adjusted_punchout') ;
      _adjustedStatus = sift.readStringFromMap(detailsMap, 'adjusted_status') ;
      _reason =sift.readStringFromMap(detailsMap, 'reason') ;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast AttendanceAdjustmentApproval response. Error message - ${e.errorMessage}');
    }

  }



  String get attendanceId => _attendanceId;

  num get empId => _empId;

  String get name => _name;

  String get date => _date;

  String? get punchIn => _punchIn;

  String? get punchOut => _punchOut;

  String? get workStatus => _workStatus;

  String? get adjustedPunchIn => _adjustedPunchIn;

  String get adjustedPunchOut => _adjustedPunchOut;

  String get adjustedStatus => _adjustedStatus;

  String get reason => _reason;

}
