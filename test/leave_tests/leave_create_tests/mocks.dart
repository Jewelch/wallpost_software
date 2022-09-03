import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> leaveSpecsResponse = {
    "joining_date": "2016-08-21",
    "leaveTypes": [
      {
        "id": 9,
        "name": "Unpaid Leave ",
        "code": "",
        "return_confirmation": "NO",
        "leaveType": 1,
        "requires_certificate": "1",
        "min_period": 3,
        "pay_items": "0"
      },
      {
        "id": 64,
        "name": "Days In Lieu",
        "code": "",
        "return_confirmation": "NO",
        "leaveType": 3,
        "requires_certificate": "0",
        "min_period": 0,
        "pay_items": "249,688,729,827,250,849,252,251"
      },
      {
        "id": 65,
        "name": "Emergency Leave ",
        "code": "",
        "return_confirmation": "NO",
        "leaveType": 1,
        "requires_certificate": "0",
        "min_period": 0,
        "pay_items": "249,688,729,250,252,251"
      },
      {
        "id": 110,
        "name": "Pilgrimage leave",
        "code": "",
        "return_confirmation": "NO",
        "leaveType": 1,
        "requires_certificate": "1",
        "min_period": 1,
        "pay_items": ""
      },
      {
        "id": 11,
        "name": "Annual Leave ",
        "code": "ANNUAL_LEAVE",
        "return_confirmation": "NO",
        "leaveType": 3,
        "requires_certificate": "0",
        "min_period": 0,
        "pay_items": "979,978,977,249,688,729,827,250,849,252,251"
      }
    ],
    "exitPermit": false,
    "leaveTicket": true,
    "ticketDetails": {
      "air_class_type": "Economy Class",
      "way_type": "Two Way",
      "no_ticket_adult": 0,
      "no_ticket_children": 0
    },
    "airportDetails": {
      "id": 27,
      "airport_origin": 857,
      "airport_destination": 521,
      "origin_detail": {"id": 857, "airport": "Doha, Qatar ", "code": "DOH"},
      "destination_detail": {"id": 521, "airport": "Cairo, Egypt ", "code": "CAI"}
    }
  };

  static List<Map<String, dynamic>> airportListResponse = [
    {
      "active_status": randomString(10),
      "airport": randomString(10),
      "code": randomString(10),
      "id": randomBetween(1000, 5000),
    },
    {
      "active_status": randomString(10),
      "airport": randomString(10),
      "code": randomString(10),
      "id": randomBetween(1000, 5000),
    },
    {
      "active_status": randomString(10),
      "airport": randomString(10),
      "code": randomString(10),
      "id": randomBetween(1000, 5000),
    },
  ];
}
