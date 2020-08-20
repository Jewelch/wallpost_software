import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/entities/user_roles.dart';

import '../../../_test_utils/map_comparer.dart';
import '../mocks.dart';

void main() {
  test('json initialization', () async {
    expect(User.fromJson(Mocks.loginResponse), isNotNull);
  });

  test('json conversion', () async {
    var user = User.fromJson(Mocks.loginResponse);

    expect(MapComparer.isMapSubsetOfAnotherMap(user.toJson(), Mocks.loginResponse), true);
  });

  test('user is a traveller', () async {
    var user = User.fromJson(Mocks.travellerMap);

    expect(user.isATraveller(), true);
    expect(user.isTravellerAccountActive(), true);
    expect(user.getTravellerId(), 'traveller_user_id');

    expect(user.isARetailer(), false);
    expect(user.isRetailerAccountActive(), false);
    expect(user.getRetailerId(), null);

    expect(user.isAnOwner(), false);
    expect(user.isOwnerAccountActive(), false);
    expect(user.getOwnerId(), null);

    expect(user.hasMultipleRoles(), false);
  });

  test('user is a retailer', () async {
    var user = User.fromJson(Mocks.retailerMap);

    expect(user.isATraveller(), false);
    expect(user.isTravellerAccountActive(), false);
    expect(user.getTravellerId(), null);

    expect(user.isARetailer(), true);
    expect(user.isRetailerAccountActive(), true);
    expect(user.getRetailerId(), 'retailer_user_id');

    expect(user.isAnOwner(), false);
    expect(user.isOwnerAccountActive(), false);
    expect(user.getOwnerId(), null);

    expect(user.hasMultipleRoles(), false);
  });

  test('user is an owner', () async {
    var user = User.fromJson(Mocks.ownerMap);

    expect(user.isATraveller(), false);
    expect(user.isTravellerAccountActive(), false);
    expect(user.getTravellerId(), null);

    expect(user.isARetailer(), false);
    expect(user.isRetailerAccountActive(), false);
    expect(user.getRetailerId(), null);

    expect(user.isAnOwner(), true);
    expect(user.isOwnerAccountActive(), true);
    expect(user.getOwnerId(), 'owner_user_id');

    expect(user.hasMultipleRoles(), false);
  });

  test('user is a traveller and retailer', () async {
    var user = User.fromJson(Mocks.loginResponse);

    expect(user.isATraveller(), true);
    expect(user.isTravellerAccountActive(), true);
    expect(user.getTravellerId(), 'some_master_id_2');

    expect(user.isARetailer(), true);
    expect(user.isRetailerAccountActive(), true);
    expect(user.getRetailerId(), 'some_master_id_1');

    expect(user.isAnOwner(), false);
    expect(user.isOwnerAccountActive(), false);
    expect(user.getOwnerId(), null);

    expect(user.hasMultipleRoles(), true);
  });

  test('user is a traveller and retailer and an owner', () async {
    var user = User.fromJson(Mocks.userWithAllTypesMap);

    expect(user.isATraveller(), true);
    expect(user.isTravellerAccountActive(), true);
    expect(user.getTravellerId(), 'traveller_user_id');

    expect(user.isARetailer(), true);
    expect(user.isRetailerAccountActive(), true);
    expect(user.getRetailerId(), 'retailer_user_id');

    expect(user.isAnOwner(), true);
    expect(user.isOwnerAccountActive(), true);
    expect(user.getOwnerId(), 'owner_user_id');

    expect(user.hasMultipleRoles(), true);
  });

  test('test updating roles', () async {
    var user = User.fromJson(Mocks.loginResponse);
    expect(user.isATraveller(), true);
    expect(user.isARetailer(), true);
    expect(user.isAnOwner(), false);

    var newRoles = UserRoles.fromJson(Mocks.ownerMap);
    user.updateRoles(newRoles);

    expect(user.isATraveller(), false);
    expect(user.isARetailer(), false);
    expect(user.isAnOwner(), true);
  });
}
