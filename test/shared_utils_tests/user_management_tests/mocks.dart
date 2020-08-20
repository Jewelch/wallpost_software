import 'package:random_string/random_string.dart';

class Mocks {
  static var loginResponse = {
    'user_id': 'someUserId',
    'username': 'someUserName@test.com',
    'company_id': 1,
    'user_master_id': 'some_user_id',
    'token': 'active_token',
    'token_expiry': DateTime.now().millisecondsSinceEpoch + 100000,
    'type': ['RETAILER', 'TRAVELLER'],
    'user_master_ids': {'RETAILER': 'some_master_id_1', 'TRAVELLER': 'some_master_id_2'},
    'date_format': 'd-m-Y',
    'date_separator': '-',
    'time_zone': 'Asia/Qatar',
    'js_date_format': 'DD-MM-YYYY',
    'company_info': {
      'name': 'Test Company',
      'address': 'Test Street',
      'email': 'test@teset.com',
      'phone_no': '9856985',
      'currency': 29
    },
    'refresh_token': 'ref_token',
    'isCroatiaCustomized': false,
    'retailer': null,
    'firstLogin': false
  };

  static Map get userMapWithInactiveSession {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['token_expiry'] = 123;
    return map;
  }

  static Map get travellerMap {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['user_master_ids'] = {'TRAVELLER': 'traveller_user_id'};
    return map;
  }

  static Map get retailerMap {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['user_master_ids'] = {'RETAILER': 'retailer_user_id'};
    return map;
  }

  static Map get inactiveRetailerMap {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['user_master_ids'] = {'INACTIVE_RETAILER': 'inactive_retailer_user_id'};
    return map;
  }

  static Map get ownerMap {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['user_master_ids'] = {'OWNER': 'owner_user_id'};
    return map;
  }

  static Map get userWithAllTypesMap {
    Map<String, dynamic> map = Map.from(loginResponse);
    map['user_master_ids'] = {
      'TRAVELLER': 'traveller_user_id',
      'RETAILER': 'retailer_user_id',
      'OWNER': 'owner_user_id'
    };
    return map;
  }

  static final Map<String, dynamic> refreshSessionResponse = {
    'token': 'activeToken',
    'token_expiry': DateTime.now().millisecondsSinceEpoch + 100000,
  };

  static Map<String, dynamic> userDetailsResponse = {
    "address": randomString(10),
    "country": randomString(10),
    "country_code": randomString(10),
    "email": randomString(10),
    "gender": randomString(10),
    "image": randomString(10),
    "land_line": randomString(10),
    "mobile": randomString(10),
    "mobile_country": randomBetween(1000, 5000),
    "name": randomString(10),
    "passport_issued_by": randomString(10),
    "passport_nationality": randomString(10),
    "passport_number": randomString(10),
    "passport_username": randomString(10),
    "postcode": randomString(10),
    "refundOption": {
      "paymentCard": [
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
        {
          "card_no": randomString(10),
          "expiry_month": randomString(10),
          "expiry_year": randomBetween(1000, 5000),
          "name": randomString(10),
          "user_master_id": randomString(10),
        },
      ],
    },
    "s3Image": randomString(10),
    "user_id": randomString(10),
    "user_master_id": randomString(10),
    "user_master_ids": {
      "INACTIVE_RETAILER": randomString(10),
      "TRAVELLER": randomString(10),
    },
    "username": randomString(10),
  };
}
