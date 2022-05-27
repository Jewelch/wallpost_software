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

      _attendanceId = sift.readStringFromMap(jsonMap, 'attendance_id');
      _empId = sift.readNumberFromMap(jsonMap, 'emp_id') ;
      _name =sift.readStringFromMap(jsonMap, 'name') ;
      _date = sift.readStringFromMap(jsonMap, 'date');
      _punchIn =sift.readStringFromMapWithDefaultValue(jsonMap, 'punch_in',null);
      _punchOut = sift.readStringFromMapWithDefaultValue(jsonMap, 'punch_out');
      _workStatus =sift.readStringFromMapWithDefaultValue(jsonMap, 'work_status',null) ;
      _adjustedPunchIn = sift.readStringFromMapWithDefaultValue(jsonMap, 'adjusted_punchin',null);
      _adjustedPunchOut =sift.readStringFromMap(jsonMap, 'adjusted_punchout') ;
      _adjustedStatus = sift.readStringFromMap(jsonMap, 'adjusted_status') ;
      _reason =sift.readStringFromMap(jsonMap, 'reason') ;
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
