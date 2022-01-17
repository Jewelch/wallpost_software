import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/permission/constants/permissions_urls.dart';
import 'package:wallpost/permission/repositories/permission_repository.dart';
import 'package:wallpost/permission/services/permission_provider.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../_mocks/mock_permission.dart';

class MockPermissionRepository extends Mock implements PermissionRepository {}

void main() {
  var successfulResponse = {'role': 'owner'};
  var mockPermissionRepository = MockPermissionRepository();
  var mockNetworkAdapter = MockNetworkAdapter();
  var permissionsProvider =
      PermissionProvider.initWith(mockPermissionRepository, mockNetworkAdapter);

  setUpAll(() {
    registerFallbackValue(MockPermission());
  });

  void _verifyNoMoreInteractions() {
    verifyNoMoreInteractions(mockPermissionRepository);
  }

  test('api request is built correctly', () async {
    Map<String, dynamic> requestParams = {};
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await permissionsProvider.getPermissions();

    expect(
        mockNetworkAdapter.apiRequest.url, PermissionsUrls.getPermissionsUrl());
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    clearInteractions(mockPermissionRepository);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await permissionsProvider.getPermissions();
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await permissionsProvider.getPermissions();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test(
      'throws WrongResponseFormatException when response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await permissionsProvider.getPermissions();
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed([<String, dynamic>{}]);

    try {
      var _ = await permissionsProvider.getPermissions();
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(successfulResponse);

    try {
      await permissionsProvider.getPermissions();
      verifyInOrder([
        () => mockPermissionRepository.savePermission(captureAny()),
      ]);
      _verifyNoMoreInteractions();
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });
}
