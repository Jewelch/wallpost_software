// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/user_management/entities/user.dart';

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
}
