import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/permission/entities/role.dart';
import 'package:wallpost/_wp_core/permission/repositories/permission_repository.dart';

import '../_mocks/mock_permission.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

void main() {
  var mockSharedPrefs = MockSharedPrefs();
  var mockPermission = MockPermission();
  late PermissionRepository permissionRepository;

  setUp(() {
    reset(mockSharedPrefs);
    reset(mockPermission);
  });

  Future<void> _initUserRepoAndWaitForInitialization() async {
    permissionRepository = PermissionRepository.withSharedPrefs(mockSharedPrefs);
    //awaiting because the shared prefs get method is async and takes a few ms to load
    //This will not be an issue in the actual app because the repo is initialized when the
    //app starts and there is time before it is actually used.
    await Future.delayed(Duration(milliseconds: 50));
  }

  test('reading permissions on initialization when no data is available', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();

    expect(permissionRepository.getPermissions(), isNull);
    verifyInOrder([
      () => mockSharedPrefs.getMap("Permission"),
    ]);
    verifyNoMoreInteractions(mockSharedPrefs);
  });

  test('reading permissions on initialization when data is available', () async {
    when(() => mockSharedPrefs.getMap('Permission')).thenAnswer(
      (_) => Future.value({'role': 'employee'}),
    );
    await _initUserRepoAndWaitForInitialization();

    expect(permissionRepository.getPermissions()!.role, Roles.employee);
  });

  test('saving new permissions, saves permissions in memory as well as locally', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    when(() => mockPermission.toJson()).thenReturn({'role': 'employee'});
    await _initUserRepoAndWaitForInitialization();

    permissionRepository.savePermission(mockPermission);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'Permission');
    expect(verificationResult.captured[1], {'role': 'employee'});
    expect(permissionRepository.getPermissions(), mockPermission);
  });

  test('saving a new permission with the already exists, replaces it', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();
    var permission1 = MockPermission();
    var permission2 = MockPermission();
    when(() => permission1.toJson()).thenReturn({'role': 'employee'});
    when(() => permission2.toJson()).thenReturn({'role': 'financial'});

    permissionRepository.savePermission(permission1);
    clearInteractions(mockSharedPrefs);
    permissionRepository.savePermission(permission2);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    expect(verificationResult.captured[1], {'role': 'financial'});

    expect(permissionRepository.getPermissions(), permission2);
  });

  test('removing a user when only one user exists clears all the data', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    when(() => mockPermission.toJson()).thenReturn({'role': 'employee'});
    await _initUserRepoAndWaitForInitialization();
    permissionRepository.savePermission(mockPermission);
    clearInteractions(mockSharedPrefs);

    permissionRepository.removePermission();
    var verificationResult = verify(() => mockSharedPrefs.removeMap(captureAny()));

    verificationResult.called(1);
    expect(verificationResult.captured[0], 'Permission');
    expect(permissionRepository.getPermissions(), null);
  });
}
