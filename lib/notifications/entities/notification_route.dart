class NotificationRoute {
  final String route;

  NotificationRoute(this.route);

  bool isATaskNotification() {
    return route.toLowerCase().contains('task');
  }

  bool isALeaveNotification() {
    return route.toLowerCase().contains('leave');
  }

  bool isAHandoverNotification() {
    return route.toLowerCase().contains('handover');
  }

  bool isAnExpenseRequestNotification() {
    return route.toLowerCase().contains('expense');
  }
}
