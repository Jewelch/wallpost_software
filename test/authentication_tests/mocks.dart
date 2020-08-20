import 'package:random_string/random_string.dart';
import 'package:wallpost/authentication/entities/credentials.dart';

class Mocks {
  static var credentials = Credentials(
    randomString(10),
    randomString(10),
  );
  static Map<String, dynamic> successfulResponse = {
    'user_id': 'someUserId',
    'username': 'someUserName@test.com',
    'company_id': 1,
    'user_master_id': '3123324asdf',
    'token': 'asdfa23423f',
    'token_expiry': 1592481489,
    'type': ['RETAILER', 'TRAVELLER'],
    'user_master_ids': {'RETAILER': '123123erwe', 'TRAVELLER': '123wewed'},
    'date_format': 'd-m-Y',
    'date_separator': '-',
    'time_zone': 'Asia/Qatar',
    'js_date_format': 'DD-MM-YYYY',
    'company_info': {
      'name': 'Test Company',
      'address': 'Test Streen',
      'email': 'test@teset.com',
      'phone_no': '9856985',
      'currency': 29
    },
    'refresh_token': 'rasdfasdf234',
    'isCroatiaCustomized': false,
    'retailer': null,
    'firstLogin': false
  };
}
