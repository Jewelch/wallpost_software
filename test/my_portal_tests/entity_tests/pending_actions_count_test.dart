import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/my_portal/entities/pending_actions_count.dart';

import '../mocks.dart';

void main() {
  test('getting total pending actions count', () async {
    var pendingActionsCount = PendingActionsCount.fromJson(Mocks.pendingActionsCountResponse);

    expect(pendingActionsCount.taskApprovalsCount, 10);
    expect(pendingActionsCount.leaveApprovalsCount, 31);
    expect(pendingActionsCount.handoverApprovalsCount, 5);
    expect(pendingActionsCount.totalPendingApprovals, 46);
    expect(pendingActionsCount.totalNotifications, 242);
  });
}
