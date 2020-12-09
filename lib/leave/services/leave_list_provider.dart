import 'dart:async';

import 'package:wallpost/_wp_core/wpapi/wp_api.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_employee_provider.dart';
import 'package:wallpost/leave/constants/leave_urls.dart';
import 'package:wallpost/leave/entities/leave_list_item.dart';

class LeaveListProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 0;
  bool _didReachListEnd = false; // ignore: unused_field
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  LeaveListProvider.initWith(this._selectedEmployeeProvider, this._networkAdapter);

  LeaveListProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 0;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveListItem>> getNext() async {
    var employee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    var url = LeaveUrls.leaveListUrl(employee.companyId, employee.v1Id, '$_pageNumber', '$_perPage');
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<List<LeaveListItem>> _processResponse(APIResponse apiResponse) async {
    var resp = leaveListResponse;

    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<LeaveListItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (resp is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = resp as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<LeaveListItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var leaveListItemList = <LeaveListItem>[];
      for (var responseMap in responseMapList) {
        var leaveListItem = LeaveListItem.fromJson(responseMap);
        leaveListItemList.add(leaveListItem);
      }
      _updatePaginationRelatedData(leaveListItemList.length);
      return leaveListItemList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }

  static List<Map<String, dynamic>> leaveListResponse = [
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_4601666e-3dd5-46d1-885c-80e968c13c0a.png",
          "company_id" : 42,
          "document_file_name" : "DOC_4601666e-3dd5-46d1-885c-80e968c13c0a.png",
          "reference_id" : 4479
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/12\/2020\/04479",
      "cancel_reason" : "",
      "clearance_status" : "0",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2020-12-07 04:16:36",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Leave Approval is pending"
        }
      },
      "family_ticket" : "",
      "handover_status" : "0",
      "id" : 4479,
      "leave_days" : 22,
      "leave_from" : "2020-12-30",
      "leave_reason" : "Annual leave",
      "leave_to" : "2021-01-21",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 138,
        "name" : "Privileged Leave (Annual)",
        "payment_cheque_type" : "1"
      },
      "leave_type_id" : 138,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 22,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "0",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 0,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_05cb1c02-4f9e-4dbe-8c84-b72c89bc063f.png",
          "company_id" : 42,
          "document_file_name" : "DOC_05cb1c02-4f9e-4dbe-8c84-b72c89bc063f.png",
          "reference_id" : 4001
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/01\/2020\/04001",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "9949687131",
      "created_on" : "2020-01-06 08:02:03",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 4001,
      "leave_days" : 2,
      "leave_from" : "2020-01-02",
      "leave_reason" : "Had to take the leave for a medical emergency",
      "leave_to" : "2020-01-03",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 2,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "Approved",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_82c2b5c4-e99e-4979-bdee-498b76e97526.png",
          "company_id" : 42,
          "document_file_name" : "DOC_82c2b5c4-e99e-4979-bdee-498b76e97526.png",
          "reference_id" : 3748
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/09\/2019\/03748",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "77453168",
      "created_on" : "2019-09-26 10:44:35",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 3748,
      "leave_days" : 1,
      "leave_from" : "2019-09-19",
      "leave_reason" : "Had to take my wife to the hospital emergency room",
      "leave_to" : "2019-09-19",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "Approved",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_6516a23f-386f-476e-a585-9a562d1c1171.png",
          "company_id" : 42,
          "document_file_name" : "DOC_6516a23f-386f-476e-a585-9a562d1c1171.png",
          "reference_id" : 3727
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/09\/2019\/03727",
      "cancel_reason" : "",
      "clearance_status" : "0",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2019-09-18 11:01:03",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 3727,
      "leave_days" : 1,
      "leave_from" : "2019-09-11",
      "leave_reason" : "Had to take my wife to the hospital",
      "leave_to" : "2019-09-11",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "Approved",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_15cd7d6c-d499-4620-a7cf-9f44080481df.png",
          "company_id" : 42,
          "document_file_name" : "DOC_15cd7d6c-d499-4620-a7cf-9f44080481df.png",
          "reference_id" : 3487
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/07\/2019\/03487",
      "cancel_reason" : "",
      "clearance_status" : "0",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2019-07-11 08:43:46",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 3487,
      "leave_days" : 1,
      "leave_from" : "2019-07-10",
      "leave_reason" : "I was down with a fever",
      "leave_to" : "2019-07-10",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "0",
        "id" : 137,
        "name" : "Sick Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 137,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "Apporved",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_f25f6bc2-35d0-429f-912b-33312b376efb.png",
          "company_id" : 42,
          "document_file_name" : "DOC_f25f6bc2-35d0-429f-912b-33312b376efb.png",
          "reference_id" : 3434
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/06\/2019\/03434",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "77453168",
      "created_on" : "2019-06-24 09:34:33",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 3434,
      "leave_days" : 1,
      "leave_from" : "2019-06-05",
      "leave_reason" : "eid holiday",
      "leave_to" : "2019-06-05",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "Approved",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_ebee82ba-aac1-42f9-9fcd-b4cfa8874164.png",
          "company_id" : 42,
          "document_file_name" : "DOC_ebee82ba-aac1-42f9-9fcd-b4cfa8874164.png",
          "reference_id" : 3190
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/05\/2019\/03190",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "77453168",
      "created_on" : "2019-05-07 11:15:41",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 3190,
      "leave_days" : 1,
      "leave_from" : "2019-05-02",
      "leave_reason" : "Sick leave",
      "leave_to" : "2019-05-02",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "0",
        "id" : 137,
        "name" : "Sick Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 137,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_310f9461-00d7-423b-b352-11cb6404e728.png",
          "company_id" : 42,
          "document_file_name" : "DOC_310f9461-00d7-423b-b352-11cb6404e728.png",
          "reference_id" : 2937
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/03\/2019\/02937",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "77453168",
      "created_on" : "2019-03-14 12:05:43",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 2937,
      "leave_days" : 1,
      "leave_from" : "2019-03-14",
      "leave_reason" : "Stomach ache and body pains",
      "leave_to" : "2019-03-14",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "0",
        "id" : 137,
        "name" : "Sick Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 137,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "Approved",
      "attach_doc" : [
        {
          "attachment" : "https:\/\/wallpostsoftware.com\/wp\/https:\/\/s3.amazonaws.com\/wallpostsoftware\/123123\/42\/leaverequest\/DOC_82b5cdbe-b9eb-4677-896b-bb312e9f0ddc.png",
          "company_id" : 42,
          "document_file_name" : "DOC_82b5cdbe-b9eb-4677-896b-bb312e9f0ddc.png",
          "reference_id" : 2691
        }
      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/01\/2019\/02691",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "mahmed@smartmanagement-its.com",
      "contact_on_leave" : "77453168",
      "created_on" : "2019-01-11 20:49:02",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 2691,
      "leave_days" : 12,
      "leave_from" : "2019-01-14",
      "leave_reason" : "Marriage",
      "leave_to" : "2019-01-25",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 138,
        "name" : "Privileged Leave (Annual)",
        "payment_cheque_type" : "1"
      },
      "leave_type_id" : 138,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 12,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [

      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/08\/2018\/02096",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "obaidahmed25@gmail.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2018-08-27 03:43:03",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 2096,
      "leave_days" : 1,
      "leave_from" : "2018-08-27",
      "leave_reason" : "I was continuously working on the Real Estate project during eid holidays and I think the work has taken some toll on me. I'm feeling a bit drowsy. Sorry for such short notice.",
      "leave_to" : "2018-08-27",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [

      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/08\/2018\/02004",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "obaidahmed25@gmail.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2018-08-07 06:26:19",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 2004,
      "leave_days" : 1,
      "leave_from" : "2018-08-07",
      "leave_reason" : "Dental checkup",
      "leave_to" : "2018-08-07",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [

      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/06\/2018\/01848",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "obaidahmed25@gmail.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2018-06-29 10:22:23",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 1848,
      "leave_days" : 1,
      "leave_from" : "2018-06-28",
      "leave_reason" : "Could not resume as I missed my return flight",
      "leave_to" : "2018-06-28",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [

      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/06\/2018\/01830",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "obaidahmed25@gmail.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2018-06-25 11:03:37",
      "departure_date" : null,
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 1830,
      "leave_days" : 1,
      "leave_from" : "2018-06-27",
      "leave_reason" : "comp off for saturday 23 jun",
      "leave_to" : "2018-06-27",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 1,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "2018-06-27",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [

      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/06\/2018\/01829",
      "cancel_reason" : "",
      "clearance_status" : "4",
      "company_id" : 42,
      "contact_email" : "obaidahmed25@gmail.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2018-06-25 11:02:22",
      "departure_date" : null,
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "4",
      "id" : 1829,
      "leave_days" : 2,
      "leave_from" : "2018-06-25",
      "leave_reason" : "need a small break",
      "leave_to" : "2018-06-26",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 136,
        "name" : "Casual Leave",
        "payment_cheque_type" : "0"
      },
      "leave_type_id" : 136,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 2,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "1",
      "return_date" : "2018-06-26",
      "return_time" : "00:00:00",
      "status" : 1,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    },
    {
      "air_class" : "",
      "approval_comments" : "",
      "attach_doc" : [

      ],
      "auto_number" : "UTTRCO-INDIA\/LEAVEREQUEST\/06\/2018\/01771",
      "cancel_reason" : "",
      "clearance_status" : "",
      "company_id" : 42,
      "contact_email" : "obaidahmed25@gmail.com",
      "contact_on_leave" : "9966687131",
      "created_on" : "2018-06-13 10:01:54",
      "departure_date" : "0000-00-00",
      "departure_time" : "00:00:00",
      "destination" : null,
      "employee" : {
        "active" : "1",
        "code" : "SMIT-IND-0019",
        "company" : 42,
        "department" : {
          "id" : 500,
          "name" : "Technical Department"
        },
        "designation" : 3078,
        "email_cc" : "",
        "email_id_office" : "mahmed@smartmanagement-its.com",
        "email_salutation" : "obaid",
        "employee_grade" : 223,
        "fullName" : "Mohammad  Obaid",
        "gender" : "Male",
        "id" : 3980,
        "join_date" : "2017-05-29",
        "line_manager" : 4681,
        "middle_name" : "",
        "name" : "Mohammad",
        "photo" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "position" : {
          "id" : 3078,
          "name" : "Team Lead"
        },
        "profile_image" : "DOC_5b2b42f9-8fd1-4538-8755-ac3e3dbab81b.jpg",
        "short_name" : "Obaid",
        "signature" : "",
        "sponser_name" : "",
        "username" : "obaid"
      },
      "employee_id" : 3980,
      "exit_required" : 0,
      "extra_info" : {
        "handover" : {
          "action" : null,
          "status" : "Not Applicable"
        }
      },
      "family_ticket" : "",
      "handover_status" : "3",
      "id" : 1771,
      "leave_days" : 10,
      "leave_from" : "2018-06-20",
      "leave_reason" : "First instalment of my annual leave",
      "leave_to" : "2018-06-29",
      "leave_type" : {
        "clearance_status" : 1,
        "handover_status" : "1",
        "id" : 138,
        "name" : "Privileged Leave (Annual)",
        "payment_cheque_type" : "1"
      },
      "leave_type_id" : 138,
      "no_ticket_adult" : 0,
      "no_ticket_children" : 0,
      "origin" : null,
      "paid_days" : 10,
      "rejected_at" : null,
      "rejected_by" : null,
      "rejected_reason" : "ushop urgency",
      "replaced_by" : null,
      "replaced_by_others" : "",
      "replaced_required" : "0",
      "return_date" : "0000-00-00",
      "return_time" : "00:00:00",
      "status" : 2,
      "ticket" : "No",
      "unpaid_days" : 0,
      "voucher" : null,
      "way_type" : ""
    }
  ];
}

