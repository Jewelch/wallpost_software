import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_common_widgets/list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';
import 'package:wallpost/notifications/entities/notification.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';
import 'package:wallpost/notifications/ui/presenters/notifications_list_presenter.dart';
import 'package:wallpost/notifications/ui/view_contracts/notifications_list_view.dart';
import 'package:wallpost/notifications/ui/views/leave_notifications_list_tile.dart';
import 'package:wallpost/notifications/ui/views/task_notifications_list_tile.dart';

class MockNotificationsListView extends Mock implements NotificationsListView {}

class MockNotificationsListProvider extends Mock implements NotificationsListProvider {}

class MockNotificationListItem extends Mock implements Notification {}

class MockUserRemover extends Mock implements UserRemover {}

void main() {
  var view = MockNotificationsListView();
  var mockNotificationsListProvider = MockNotificationsListProvider();
  late NotificationsListPresenter presenter;

  var notification1 = MockNotificationListItem();
  var notification2 = MockNotificationListItem();
  List<Notification> _notificationList = [notification1, notification2];

  setUpAll(() {
    when(() => notification1.notificationId).thenReturn("id1");
    when(() => notification1.message).thenReturn("message1");
    when(() => notification1.isATaskNotification).thenReturn(true);

    when(() => notification2.notificationId).thenReturn("id2");
    when(() => notification2.message).thenReturn("message2");
    when(() => notification2.isALeaveNotification).thenReturn(true);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockNotificationsListProvider);
  }

  void _resetAllMockInteractions() {
    clearInteractions(view);
    clearInteractions(mockNotificationsListProvider);
  }

  setUp(() {
    presenter = NotificationsListPresenter.initWith(
      view,
      mockNotificationsListProvider,
    );
    _resetAllMockInteractions();
  });

  test('shows loader only on the first run', () async {
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);

    //then
    expect(presenter.getNumberOfItems(), 1);
    expect(presenter.getViewAtIndex(0) is LoaderListTile, true);
    verifyInOrder([
      () => mockNotificationsListProvider.didReachListEnd,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving notifications fails on the first run', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadNextListOfNotifications();

    expect(presenter.getNumberOfItems(), 1);
    expect(presenter.getViewAtIndex(0) is ErrorListTile, true);
    expect((presenter.getViewAtIndex(0) as ErrorListTile).message,
        '${InvalidResponseException().userReadableMessage}\n\nTap here to reload.');
    //then
    verifyInOrder([
      () => mockNotificationsListProvider.isLoading,
      () => mockNotificationsListProvider.didReachListEnd,
      () => view.reloadData(),
      () => mockNotificationsListProvider.getNext(),
      () => view.reloadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving empty list on the first run and there are no more items', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(true);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer((_) => Future.value(List.empty()));

    //when
    await presenter.loadNextListOfNotifications();

    //todo add expect
    //then
    verifyInOrder([
      () => mockNotificationsListProvider.isLoading,
      () => mockNotificationsListProvider.didReachListEnd,
      () => view.reloadData(),
      () => mockNotificationsListProvider.getNext(),
      () => view.reloadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('retrieving notifications successfully with no more items', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(true);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer((_) => Future.value(_notificationList));

    //when
    await presenter.loadNextListOfNotifications();

    //todo add 2 more notifications to the list of types handover and expense request in the setup function
    //then
    expect(presenter.getNumberOfItems(), 2);
    expect(presenter.getViewAtIndex(0) is TaskNotificationsListTile, true);
    expect(presenter.getViewAtIndex(1) is LeaveNotificationsListTile, true);
    verifyInOrder([
      () => mockNotificationsListProvider.isLoading,
      () => mockNotificationsListProvider.didReachListEnd,
      () => view.reloadData(),
      () => mockNotificationsListProvider.getNext(),
      () => view.reloadData(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //note are we really checking the message did appear?

/*
test('retrieving notifications successfully with  more items', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(true);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);


    + show loader at the end
 */

  /*
test('retrieving notifications successfully with  failure on loading more items', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(true);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);
    //throw error on load more items being called the second time


    + show error tile  at the end
 */

  test('retrieving notifications did reach list end', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(true);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer((_) => Future.value(_notificationList));

    //when
    await presenter.loadNextListOfNotifications();

    //then
    verifyInOrder([
      () => mockNotificationsListProvider.isLoading,
      () => mockNotificationsListProvider.didReachListEnd,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
