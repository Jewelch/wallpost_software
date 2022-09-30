import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/dashboard/company_dashboard/ui/presenters/company_dashboard_presenter.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_current_user_provider.dart';
import '../../_mocks/mock_employee.dart';
import '../../_mocks/mock_user.dart';

void main() {
  var user = MockUser();
  var company = MockCompany();
  var currentUserProvider = MockCurrentUserProvider();
  var selectedCompanyProvider = MockCompanyProvider();
  var presenter = CompanyDashboardPresenter.initWith(selectedCompanyProvider, currentUserProvider);

  setUpAll(() {
    when(() => currentUserProvider.getCurrentUser()).thenReturn(user);
    when(() => selectedCompanyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
  });

  test("get profile image url", () {
    when(() => user.profileImageUrl).thenReturn("www.url.com");

    expect(presenter.getProfileImageUrl(), "www.url.com");
  });

  test("get should show owner dashboard", () {
    var employee = MockEmployee();
    when(() => company.employee).thenReturn(employee);

    when(() => employee.isOwner()).thenReturn(true);
    expect(presenter.shouldShowOwnerDashboard(), true);
    expect(presenter.shouldShowEmployeeDashboard(), false);

    when(() => employee.isGM()).thenReturn(true);
    expect(presenter.shouldShowOwnerDashboard(), true);
    expect(presenter.shouldShowEmployeeDashboard(), false);
  });

  test("get should show employee dashboard", () {
    var employee = MockEmployee();
    when(() => company.employee).thenReturn(employee);

    when(() => employee.isOwner()).thenReturn(false);
    when(() => employee.isGM()).thenReturn(false);

    expect(presenter.shouldShowEmployeeDashboard(), true);
    expect(presenter.shouldShowOwnerDashboard(), false);
  });
}
