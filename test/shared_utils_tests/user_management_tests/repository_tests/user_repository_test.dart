import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/_shared/user_management/entities/user.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';

import '../mocks.dart';

class MockUser extends Mock implements User {}

class MockSharedPrefs extends Mock implements SecureSharedPrefs {}

void main() {
  var mockUser = MockUser();
  var mockSharedPrefs = MockSharedPrefs();
  var userRepository = UserRepository.withSharePrefs(mockSharedPrefs);

  setUp(() {
    reset(mockUser);
    reset(mockSharedPrefs);
  });

  test('sucessfully storing user data', () async {
    when(mockUser.toJson()).thenReturn({'user': 'json'});
    when(mockUser.username).thenReturn('someUserName');

    userRepository.saveNewCurrentUser(mockUser);

    var verificationResult = verify(mockSharedPrefs.saveMap(captureAny, captureAny));
    verificationResult.called(2);
    expect(verificationResult.captured[0], 'someUserName-userInfo');
    expect(verificationResult.captured[1], {'user': 'json'});
    expect(verificationResult.captured[2], 'currentUser');
    expect(verificationResult.captured[3], {'username': 'someUserName'});
  });

  test('getting current user when no user has been added returns null', () async {
    var user = await userRepository.getCurrentUser();

    expect(user, null);
    verify(mockSharedPrefs.getMap(any)).called(1);
  });

  test('getting a user', () async {
    when(mockSharedPrefs.getMap(any)).thenAnswer((_) => Future.value(Mocks.loginResponse));

    var returnedUser = await userRepository.getCurrentUser();

    expect(verify(mockSharedPrefs.getMap(captureAny)).captured, ['currentUser', 'someUserName@test.com-userInfo']);
    expect(returnedUser.username, 'someUserName@test.com');
  });

  test('removing a user', () async {
    userRepository.removeUser(mockUser);

    var verificationResult = verify(mockSharedPrefs.removeMap(captureAny));
    verificationResult.called(2);
    expect(verificationResult.captured[0], '${mockUser.username}-userInfo');
    expect(verificationResult.captured[1], 'currentUser');
  });

}
