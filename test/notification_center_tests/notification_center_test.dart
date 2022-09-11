import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/notification_center/notification_center.dart';
import 'package:wallpost/notification_center/notification_router.dart';
import 'package:wallpost/notification_center/services/notification_count_updater.dart';
import 'package:wallpost/notification_center/services/notification_token_synchronizer.dart';

import '../_mocks/mock_current_user_provider.dart';
import '../_mocks/mock_network_adapter.dart';
import '../_mocks/mock_notification_observer.dart';
import 'mock_firebase_wrapper.dart';
import 'mocks.dart';

class MockTokenSynchronizer extends Mock implements NotificationTokenSynchronizer {}

class MockNotificationCountUpdater extends Mock implements NotificationCountUpdater {}

class MockNotificationRouter extends Mock implements NotificationRouter {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNotificationObserver observer;
  late CurrentUserProvider userProvider;
  late MockFirebaseWrapper firebaseWrapper;
  late MockTokenSynchronizer tokenSynchronizer;
  late MockNotificationCountUpdater notificationCountUpdater;
  late MockNotificationRouter notificationRouter;
  late NotificationCenter notificationCenter;

  setUp(() {
    observer = MockNotificationObserver();
    userProvider = MockCurrentUserProvider();
    firebaseWrapper = MockFirebaseWrapper();
    tokenSynchronizer = MockTokenSynchronizer();
    notificationCountUpdater = MockNotificationCountUpdater();
    notificationRouter = MockNotificationRouter();
    notificationCenter = NotificationCenter.initWith(
      userProvider,
      firebaseWrapper,
      tokenSynchronizer,
      notificationCountUpdater,
      notificationRouter,
    );

    when(() => notificationRouter.goToExpenseDetailScreen(any(), any())).thenReturn(null);
    when(() => notificationRouter.goToExpenseDetailScreenForApproval(any(), any())).thenReturn(null);
    when(() => notificationRouter.goToLeaveDetailScreen(any(), any())).thenReturn(null);
    when(() => notificationRouter.goToLeaveDetailScreenForApproval(any(), any())).thenReturn(null);
    when(() => notificationRouter.goToAttendanceAdjustmentDetailScreen(any(), any())).thenReturn(null);
    when(() => notificationRouter.goToAttendanceAdjustmentDetailScreenForApproval(any(), any())).thenReturn(null);
    when(() => observer.key).thenReturn("someKey");
    when(() => observer.callback).thenReturn((_) {});
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(userProvider);
    verifyNoMoreInteractions(tokenSynchronizer);
    verifyNoMoreInteractions(notificationCountUpdater);
    verifyNoMoreInteractions(notificationRouter);
    verifyNoMoreInteractions(observer);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(userProvider);
    clearInteractions(tokenSynchronizer);
    clearInteractions(notificationCountUpdater);
    clearInteractions(notificationRouter);
    verifyNoMoreInteractions(observer);
  }

  group('tests for setup', () {
    test('deletes the token if the user is not logged in', () async {
      when(() => userProvider.isLoggedIn()).thenReturn(false);

      notificationCenter.setupAndHandlePushNotifications();

      expect(firebaseWrapper.didCallDeleteToken, true);
      verifyInOrder([
        () => userProvider.isLoggedIn(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('does not sync the token if the token is null and setting the listeners', () async {
      when(() => userProvider.isLoggedIn()).thenReturn(true);
      firebaseWrapper.tokenToReturn = null;

      await notificationCenter.setupAndHandlePushNotifications();

      expect(firebaseWrapper.didCallGetToken, true);
      expect(firebaseWrapper.didCallAddFirebaseTokenUpdateListener, isNotNull);
      expect(firebaseWrapper.didCallAddNotificationListeners, isNotNull);
      verifyInOrder([
        () => userProvider.isLoggedIn(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully syncing the token and setting the listeners', () async {
      when(() => userProvider.isLoggedIn()).thenReturn(true);
      firebaseWrapper.tokenToReturn = "firebaseToken";

      await notificationCenter.setupAndHandlePushNotifications();

      expect(firebaseWrapper.didCallGetToken, true);
      expect(firebaseWrapper.didCallAddFirebaseTokenUpdateListener, isNotNull);
      expect(firebaseWrapper.didCallAddNotificationListeners, isNotNull);
      verifyInOrder([
        () => userProvider.isLoggedIn(),
        () => tokenSynchronizer.syncToken("firebaseToken"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group("tests for updating count", () {
    test("failure to update count does nothing", () async {
      when(() => notificationCountUpdater.updateCount()).thenAnswer((_) => Future.error(InvalidResponseException()));

      await notificationCenter.updateCount();

      verifyInOrder([
        () => notificationCountUpdater.updateCount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("updating count successfully", () async {
      when(() => notificationCountUpdater.updateCount()).thenAnswer((_) => Future.value(null));

      await notificationCenter.updateCount();

      verifyInOrder([
        () => notificationCountUpdater.updateCount(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('test routing when handling background notification', () {
    Future<void> _setup() async {
      when(() => userProvider.isLoggedIn()).thenReturn(true);
      firebaseWrapper.tokenToReturn = "firebaseToken";
      await notificationCenter.setupAndHandlePushNotifications();
      _clearInteractionsOnAllMocks();
    }

    test('expense approval required notification', () async {
      //given
      await _setup();

      //when
      var notification = Mocks.expenseApprovalRequiredNotification;
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToExpenseDetailScreenForApproval("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('expense approved notification', () async {
      //given
      await _setup();
      var notification = Mocks.expenseApprovedNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToExpenseDetailScreen("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('expense rejected notification', () async {
      //given
      await _setup();
      var notification = Mocks.expenseRejectedNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToExpenseDetailScreen("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('leave approval required notification', () async {
      //given
      await _setup();
      var notification = Mocks.leaveApprovalRequiredNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToLeaveDetailScreenForApproval("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('leave approved notification', () async {
      //given
      await _setup();
      var notification = Mocks.leaveApprovedNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToLeaveDetailScreen("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('leave rejected notification', () async {
      //given
      await _setup();
      var notification = Mocks.leaveRejectedNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToLeaveDetailScreen("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('attendance adjustment approval required notification', () async {
      //given
      await _setup();
      var notification = Mocks.attendanceAdjustmentApprovalRequiredNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToAttendanceAdjustmentDetailScreenForApproval("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('attendance adjustment approved notification', () async {
      //given
      await _setup();
      var notification = Mocks.attendanceAdjustmentApprovedNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToAttendanceAdjustmentDetailScreen("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('attendance adjustment rejected notification', () async {
      //given
      await _setup();
      var notification = Mocks.attendanceAdjustmentRejectedNotification;

      //when
      firebaseWrapper.didOpenAppByTappingOnNotificationCallback!.call(notification);

      //then
      verifyInOrder([
        () => notificationRouter.goToAttendanceAdjustmentDetailScreen("12", "15"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for handling foreground notification', () {
    Future<void> _setup() async {
      when(() => userProvider.isLoggedIn()).thenReturn(true);
      firebaseWrapper.tokenToReturn = "firebaseToken";
      await notificationCenter.setupAndHandlePushNotifications();
      _clearInteractionsOnAllMocks();
    }

    test('adding and removing expense approval required notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.expenseApprovalRequiredNotification;

      //adding observer
      notificationCenter.addExpenseApprovalRequiredObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing expense approved notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.expenseApprovedNotification;

      //adding observer
      notificationCenter.addExpenseApprovedObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing expense rejected notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.expenseRejectedNotification;

      //adding observer
      notificationCenter.addExpenseRejectedObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing leave approval required notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.leaveApprovalRequiredNotification;

      //adding observer
      notificationCenter.addLeaveApprovalRequiredObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing leave approved notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.leaveApprovedNotification;

      //adding observer
      notificationCenter.addLeaveApprovedObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing leave rejected notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.leaveRejectedNotification;

      //adding observer
      notificationCenter.addLeaveRejectedObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing attendance adjustment approval required notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.attendanceAdjustmentApprovalRequiredNotification;

      //adding observer
      notificationCenter.addAttendanceAdjustmentApprovalRequiredObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing attendance adjustment approved notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.attendanceAdjustmentApprovedNotification;

      //adding observer
      notificationCenter.addAttendanceAdjustmentApprovedObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('adding and removing attendance adjustment rejected notification observer', () async {
      //given
      await _setup();
      var notification = Mocks.attendanceAdjustmentRejectedNotification;

      //adding observer
      notificationCenter.addAttendanceAdjustmentRejectedObserver(observer);
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.callback.call(notification),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();

      //removing observer
      notificationCenter.removeObserverFromAllChannels(key: "someKey");
      firebaseWrapper.didReceiveNotificationInForegroundCallback!.call(notification);
      verifyInOrder([
        () => observer.key,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });
}
