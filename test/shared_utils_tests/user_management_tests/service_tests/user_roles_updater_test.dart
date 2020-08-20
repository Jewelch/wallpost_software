import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/user_management/constants/get_user_roles_filters.dart';
import 'package:wallpost/_shared/user_management/constants/user_management_urls.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';
import 'package:wallpost/_shared/user_management/services/user_roles_updater.dart';

import '../../../_mocks/mock_network_adapter.dart';
import '../mocks.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  var user = User.fromJson(Mocks.loginResponse);
  var filters = GetUserRolesFilters();
  var mockUserRepository = MockUserRepository();
  var mockNetworkAdapter = MockNetworkAdapter();
  var userRolesUpdater = UserRolesUpdater.initWith(mockUserRepository, mockNetworkAdapter);

  setUp(() {
    filters.companyId = user.companyId;
    filters.userId = user.userId;
  });

  setUp(() {
    reset(mockUserRepository);
    when(mockUserRepository.getCurrentUser()).thenAnswer((_) => Future.value(user));
  });

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(Mocks.userDetailsResponse);

    var _ = await userRolesUpdater.updateRoles();

    expect(mockNetworkAdapter.apiRequest.url, UserManagementUrls.getUserRolesUrl(filters));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await userRolesUpdater.updateRoles();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await userRolesUpdater.updateRoles();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await userRolesUpdater.updateRoles();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await userRolesUpdater.updateRoles();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(Mocks.userDetailsResponse);

    var _ = await userRolesUpdater.updateRoles();

    var invocationResult = verify(mockUserRepository.saveNewCurrentUser(captureAny));
    expect(invocationResult.callCount, 1);
    expect((invocationResult.captured.single as User).isATraveller(), true);
    expect((invocationResult.captured.single as User).isTravellerAccountActive(), true);
    expect((invocationResult.captured.single as User).isARetailer(), true);
    expect((invocationResult.captured.single as User).isRetailerAccountActive(), false);
    expect((invocationResult.captured.single as User).isAnOwner(), false);
    expect((invocationResult.captured.single as User).isOwnerAccountActive(), false);
  });
}
