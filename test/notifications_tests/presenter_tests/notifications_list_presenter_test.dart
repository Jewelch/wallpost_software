import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/invalid_response_exception.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';
import 'package:wallpost/company_list/services/company_details_provider.dart';
import 'package:wallpost/_wp_core/user_management/services/user_remover.dart';
import 'package:wallpost/notifications/entities/notification.dart';
import 'package:wallpost/notifications/services/notifications_list_provider.dart';
import 'package:wallpost/notifications/ui/presenters/notifications_list_presenter.dart';

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
    when(() => notification2.notificationId).thenReturn("id2");
    when(() => notification2.message).thenReturn("message2");
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

  test('retrieving notifications successfully', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer((_) => Future.value(_notificationList));

    //when
    await presenter.loadNextListOfNotifications();

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

  //note are we really checking the message did appear?
  test('retrieving notifications successfully with empty list', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer((_) => Future.value(List.empty()));

    //when
    await presenter.loadNextListOfNotifications();

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

  test('retrieving notifications failed', () async {
    //given
    when(() => mockNotificationsListProvider.isLoading).thenReturn(false);
    when(() => mockNotificationsListProvider.didReachListEnd).thenReturn(false);
    when(() => mockNotificationsListProvider.getNext()).thenAnswer(
      (realInvocation) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadNextListOfNotifications();

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

}
