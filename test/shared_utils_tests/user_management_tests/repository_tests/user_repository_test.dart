import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';

import '../../../_mocks/mock_user.dart';
import '../mocks.dart';

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

void main() {
  var mockUser = MockUser();
  var mockSharedPrefs = MockSharedPrefs();
  UserRepository userRepository;

  setUp(() {
    reset(mockUser);
    reset(mockSharedPrefs);
    userRepository = UserRepository.withSharedPrefs(mockSharedPrefs);
  });

  test('reading user data on initialization when no data is available', () async {
    var verificationResult = verify(mockSharedPrefs.getMap(captureAny));

    verificationResult.called(2);
    expect(verificationResult.captured[0], 'users');
    expect(verificationResult.captured[1], 'currentUser');
    expect(userRepository.getCurrentUser(), isNull);
    expect(userRepository.getAllUsers(), []);
  });

  test('reading user data on initialization when data is available', () async {
    when(mockSharedPrefs.getMap('users')).thenAnswer(
      (_) => Future.value({
        'allUsers': [Mocks.loginResponse]
      }),
    );
    when(mockSharedPrefs.getMap('currentUser')).thenAnswer(
      (_) => Future.value({'username': 'someUserName'}),
    );
    userRepository = UserRepository.withSharedPrefs(mockSharedPrefs);
    //awaiting because the shared prefs takes get method is async and takes a few ms to load
    //This will not be an issue in the actual app because the repo is initialized when the
    //app starts and there is time before it is actually used.
    await Future.delayed(Duration(milliseconds: 200));

    expect(userRepository.getCurrentUser().username, 'someUserName');
    expect(userRepository.getAllUsers().length, 1);
    expect(userRepository.getAllUsers()[0].username, 'someUserName');
  });

  test('saving new current user, saves user in memory as well as locally', () async {
    when(mockUser.toJson()).thenReturn({'user': 'json'});
    when(mockUser.username).thenReturn('someUserName');

    userRepository.saveNewCurrentUser(mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

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

  test('updating user info, updates the user info, and stores it locally', () async {
    when(mockUser.toJson()).thenReturn({'user': 'json'});
    when(mockUser.username).thenReturn('someUserName');
    userRepository.saveNewCurrentUser(mockUser);
    when(mockUser.toJson()).thenReturn({'updated': 'data'});
    reset(mockSharedPrefs);

    userRepository.updateUser(mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

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

  test('saving a user with that already exists, replaces it', () async {
    var mockUser1 = MockUser();
    var mockUser2 = MockUser();
    when(mockUser1.username).thenReturn("username");
    when(mockUser2.username).thenReturn("username");
    when(mockUser1.toJson()).thenReturn({'user1': 'json'});
    when(mockUser2.toJson()).thenReturn({'user2': 'json'});

    userRepository.saveNewCurrentUser(mockUser1);
    clearInteractions(mockSharedPrefs);
    userRepository.saveNewCurrentUser(mockUser2);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

    expect(verificationResult.captured[1], {
      'allUsers': [
        {'user2': 'json'}
      ]
    });
    expect(userRepository.getCurrentUser(), mockUser2);
  });

  test('removing a user when only one user exists clears all the data', () async {
    when(mockUser.username).thenReturn('someUserName');
    userRepository.saveNewCurrentUser(mockUser);
    clearInteractions(mockSharedPrefs);

    userRepository.removeUser(mockUser);
    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));

    verificationResult.called(2);
    expect(verificationResult.captured[0], 'users');
    expect(verificationResult.captured[1], {'allUsers': []});
    expect(verificationResult.captured[2], 'currentUser');
    expect(verificationResult.captured[3], {'username': null});
    expect(userRepository.getCurrentUser(), null);
  });

  test('removing a user when multiple users are present selects the next user', () async {
    var mockUser1 = MockUser();
    var mockUser2 = MockUser();
    when(mockUser1.username).thenReturn("username1");
    when(mockUser2.username).thenReturn("username2");
    userRepository.saveNewCurrentUser(mockUser1);
    userRepository.saveNewCurrentUser(mockUser2);

    userRepository.removeUser(mockUser2);

    expect(userRepository.getCurrentUser(), mockUser1);
  });
}
