import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/dashboard/company_dashboard/ui/presenters/company_dashboard_presenter.dart';

import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_permissions_provider.dart';
import '../../_mocks/mock_user.dart';

void main() {
  var user = MockUser();
  var currentUserProvider = MockCurrentUserProvider();
  var permissionsProvider = MockPermissionsProvider();
  var presenter = CompanyDashboardPresenter.initWith(currentUserProvider, permissionsProvider);

  setUpAll(() {
    when(() => currentUserProvider.getCurrentUser()).thenReturn(user);
  });

  test("get profile image url", () {
    when(() => user.profileImageUrl).thenReturn("www.url.com");

    expect(presenter.getProfileImageUrl(), "www.url.com");
  });

  test("dashboard access", () {
    when(() => permissionsProvider.shouldShowOwnerDashboard()).thenReturn(true);
    when(() => permissionsProvider.shouldShowManagerDashboard()).thenReturn(false);
    when(() => permissionsProvider.shouldShowEmployeeDashboard()).thenReturn(false);
    expect(presenter.shouldShowOwnerDashboard(), true);
    expect(presenter.shouldShowManagerDashboard(), false);
    expect(presenter.shouldShowEmployeeDashboard(), false);

    when(() => permissionsProvider.shouldShowOwnerDashboard()).thenReturn(false);
    when(() => permissionsProvider.shouldShowManagerDashboard()).thenReturn(true);
    when(() => permissionsProvider.shouldShowEmployeeDashboard()).thenReturn(false);
    expect(presenter.shouldShowOwnerDashboard(), false);
    expect(presenter.shouldShowManagerDashboard(), true);
    expect(presenter.shouldShowEmployeeDashboard(), false);

    when(() => permissionsProvider.shouldShowOwnerDashboard()).thenReturn(false);
    when(() => permissionsProvider.shouldShowManagerDashboard()).thenReturn(false);
    when(() => permissionsProvider.shouldShowEmployeeDashboard()).thenReturn(true);
    expect(presenter.shouldShowOwnerDashboard(), false);
    expect(presenter.shouldShowManagerDashboard(), false);
    expect(presenter.shouldShowEmployeeDashboard(), true);
  });
}
