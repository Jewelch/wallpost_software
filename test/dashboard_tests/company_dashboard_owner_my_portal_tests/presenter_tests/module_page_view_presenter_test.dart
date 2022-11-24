import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/presenters/module_page_view_presenter.dart';

import '../../../_mocks/mock_permissions_provider.dart';

void main() {
  var permissionsProvider = MockPermissionsProvider();
  late ModulePageViewPresenter presenter;

  setUpAll(() {
    presenter = ModulePageViewPresenter.initWith(permissionsProvider);
  });

  test("get modules that can be shown in the dashboard", () {
    expect(presenter.getAllDashboardModules(), [
      Module.Crm,
      Module.Hr,
      Module.Restaurant,
      Module.Retail,
    ]);
  });

  test("get modules", () {
    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(false);
    expect(presenter.getNumberOfModules(), 0);
    expect(presenter.getModules(), []);
    expect(presenter.getModuleNames(), []);

    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(false);
    expect(presenter.getNumberOfModules(), 1);
    expect(presenter.getModules(), [Module.Crm]);
    expect(presenter.getModuleNames(), [
      Module.Crm.toReadableString(),
    ]);

    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(false);
    expect(presenter.getNumberOfModules(), 2);
    expect(presenter.getModules(), [Module.Crm, Module.Hr]);
    expect(presenter.getModuleNames(), [
      Module.Crm.toReadableString(),
      Module.Hr.toReadableString(),
    ]);

    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(false);
    expect(presenter.getNumberOfModules(), 3);
    expect(presenter.getModules(), [Module.Crm, Module.Hr, Module.Restaurant]);
    expect(presenter.getModuleNames(), [
      Module.Crm.toReadableString(),
      Module.Hr.toReadableString(),
      Module.Restaurant.toReadableString(),
    ]);

    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(true);
    expect(presenter.getNumberOfModules(), 4);
    expect(presenter.getModules(), [Module.Crm, Module.Hr, Module.Restaurant, Module.Retail]);
    expect(presenter.getModuleNames(), [
      Module.Crm.toReadableString(),
      Module.Hr.toReadableString(),
      Module.Restaurant.toReadableString(),
      Module.Retail.toReadableString(),
    ]);
  });

  test("get should display modules if user can access one or more modules", () {
    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(false);
    expect(presenter.shouldDisplayModules(), false);

    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(false);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(false);
    expect(presenter.shouldDisplayModules(), true);

    when(() => permissionsProvider.canAccessCrmModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessHrModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRestaurantModule()).thenReturn(true);
    when(() => permissionsProvider.canAccessRetailModule()).thenReturn(true);
    expect(presenter.shouldDisplayModules(), true);
  });

  test("select module at index", () {
    presenter.selectModuleAtIndex(3);

    expect(presenter.selectedModuleIndex, 3);
  });
}
