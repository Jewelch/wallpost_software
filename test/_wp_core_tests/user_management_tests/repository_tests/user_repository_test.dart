import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_wp_core/user_management/repositories/user_repository.dart';

import '../../../_mocks/mock_user.dart';
import '../../authentication_tests/mocks.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

void main() {
  var mockUser = MockUser();
  var mockSharedPrefs = MockSharedPrefs();
  late UserRepository userRepository;

  setUp(() {
    reset(mockUser);
    reset(mockSharedPrefs);
  });

  Future<void> _initUserRepoAndWaitForInitialization() async {
    userRepository = UserRepository.initWith(mockSharedPrefs);
    //awaiting because the shared prefs get method is async and takes a few ms to load
    //This will not be an issue in the actual app because the repo is initialized when the
    //app starts and there is time before it is actually used.
    await Future.delayed(Duration(milliseconds: 50));
  }

  test('reading user data on initialization when no data is available', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();

    expect(userRepository.getCurrentUser(), isNull);
    expect(userRepository.getAllUsers(), []);
    verifyInOrder([
      () => mockSharedPrefs.getMap("users"),
      () => mockSharedPrefs.getMap("currentUser"),
    ]);
    verifyNoMoreInteractions(mockSharedPrefs);
  });

  test('reading user data on initialization when data is available', () async {
    when(() => mockSharedPrefs.getMap('users')).thenAnswer(
      (_) => Future.value({
        'allUsers': [Mocks.loginResponse]
      }),
    );
    when(() => mockSharedPrefs.getMap('currentUser')).thenAnswer(
      (_) => Future.value({'username': 'someUserName'}),
    );
    await _initUserRepoAndWaitForInitialization();

    expect(userRepository.getCurrentUser()!.username, 'someUserName');
    expect(userRepository.getAllUsers().length, 1);
    expect(userRepository.getAllUsers()[0].username, 'someUserName');
  });

  test('saving new current user, saves user in memory as well as locally', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();
    when(() => mockUser.toJson()).thenReturn({'user': 'json'});
    when(() => mockUser.username).thenReturn('someUserName');

    userRepository.saveNewCurrentUser(mockUser);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    verificationResult.called(2);
    expect(verificationResult.captured[0], 'users');
    expect(verificationResult.captured[1], {
      'allUsers': [
        {'user': 'json'}
      ]
    });
    expect(verificationResult.captured[2], 'currentUser');
    expect(verificationResult.captured[3], {'username': 'someUserName'});
    expect(userRepository.getCurrentUser(), mockUser);
  });

  test('saving a user with that already exists, replaces it', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();
    var mockUser1 = MockUser();
    var mockUser2 = MockUser();
    when(() => mockUser1.username).thenReturn("username");
    when(() => mockUser2.username).thenReturn("username");
    when(() => mockUser1.toJson()).thenReturn({'user1': 'json'});
    when(() => mockUser2.toJson()).thenReturn({'user2': 'json'});

    userRepository.saveNewCurrentUser(mockUser1);
    clearInteractions(mockSharedPrefs);
    userRepository.saveNewCurrentUser(mockUser2);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    expect(verificationResult.captured[1], {
      'allUsers': [
        {'user2': 'json'}
      ]
    });
    expect(userRepository.getCurrentUser(), mockUser2);
  });

  test('updating user info, updates the user info, and stores it locally', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();
    when(() => mockUser.toJson()).thenReturn({'user': 'json'});
    when(() => mockUser.username).thenReturn('someUserName');
    userRepository.saveNewCurrentUser(mockUser);
    when(() => mockUser.toJson()).thenReturn({'updated': 'data'});
    reset(mockSharedPrefs);

    userRepository.updateUser(mockUser);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    verificationResult.called(2);
    expect(verificationResult.captured[0], 'users');
    expect(verificationResult.captured[1], {
      'allUsers': [
        {'updated': 'data'}
      ]
    });
    expect(verificationResult.captured[2], 'currentUser');
    expect(verificationResult.captured[3], {'username': 'someUserName'});
  });

  test('removing a user when only one user exists clears all the data', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();
    when(() => mockUser.username).thenReturn('someUserName');
    when(() => mockUser.toJson()).thenReturn({});
    userRepository.saveNewCurrentUser(mockUser);
    clearInteractions(mockSharedPrefs);

    userRepository.removeUser(mockUser);
    var verificationResult = verify(() => mockSharedPrefs.saveMap(captureAny(), captureAny()));

    verificationResult.called(2);
    expect(verificationResult.captured[0], 'users');
    expect(verificationResult.captured[1], {'allUsers': []});
    expect(verificationResult.captured[2], 'currentUser');
    expect(verificationResult.captured[3], {'username': null});
    expect(userRepository.getCurrentUser(), null);
  });

  test('removing a user when multiple users are present selects the next user', () async {
    when(() => mockSharedPrefs.getMap(any())).thenAnswer((_) => Future.value(null));
    await _initUserRepoAndWaitForInitialization();
    var mockUser1 = MockUser();
    var mockUser2 = MockUser();
    when(() => mockUser1.username).thenReturn("username1");
    when(() => mockUser2.username).thenReturn("username2");
    when(() => mockUser1.toJson()).thenReturn({});
    when(() => mockUser2.toJson()).thenReturn({});
    userRepository.saveNewCurrentUser(mockUser1);
    userRepository.saveNewCurrentUser(mockUser2);

    userRepository.removeUser(mockUser2);

    expect(userRepository.getCurrentUser(), mockUser1);
  });
}
