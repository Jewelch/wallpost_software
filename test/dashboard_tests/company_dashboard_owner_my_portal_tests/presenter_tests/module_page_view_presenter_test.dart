import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/presenters/module_page_view_presenter.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';

void main() {
  var company = MockCompany();
  var companyProvider = MockCompanyProvider();
  late ModulePageViewPresenter presenter;

  setUpAll(() {
    when(() => companyProvider.getSelectedCompanyForCurrentUser()).thenReturn(company);
    presenter = ModulePageViewPresenter.initWith(companyProvider);
  });

  test("get number of modules", () {
    when(() => company.modules).thenReturn([]);
    expect(presenter.getNumberOfModules(), 0);

    when(() => company.modules).thenReturn([Module.Retail]);
    expect(presenter.getNumberOfModules(), 1);

    when(() => company.modules).thenReturn([Module.Retail, Module.Restaurant]);
    expect(presenter.getNumberOfModules(), 2);
  });

  test("get should display modules", () {
    when(() => company.modules).thenReturn([]);
    expect(presenter.shouldDisplayModules(), false);

    when(() => company.modules).thenReturn([Module.Retail]);
    expect(presenter.shouldDisplayModules(), true);

    when(() => company.modules).thenReturn([Module.Retail, Module.Restaurant]);
    expect(presenter.shouldDisplayModules(), true);
  });

  test("get modules filters out only those modules that are to be shown", () {
    when(() => company.modules).thenReturn([]);
    expect(presenter.getModules(), []);

    when(() => company.modules).thenReturn([Module.Retail]);
    expect(presenter.getModules(), [Module.Retail]);

    when(() => company.modules).thenReturn([Module.Restaurant]);
    expect(presenter.getModules(), [Module.Restaurant]);

    when(() => company.modules).thenReturn([Module.Hr]);
    expect(presenter.getModules(), [Module.Hr]);

    when(() => company.modules).thenReturn([Module.Crm]);
    expect(presenter.getModules(), [Module.Crm]);

    when(() => company.modules).thenReturn([Module.Finance]);
    expect(presenter.getModules(), []);

    when(() => company.modules).thenReturn(Module.values);
    expect(presenter.getModules(), [
      Module.Crm,
      Module.Hr,
      Module.Restaurant,
      Module.Retail,
    ]);
  });

  test("get module names", () {
    when(() => company.modules).thenReturn([Module.Retail, Module.Restaurant]);

    expect(presenter.getModuleNames(), [
      Module.Restaurant.toReadableString(),
      Module.Retail.toReadableString(),
    ]);
  });

  test("select module at index", () {
    presenter.selectModuleAtIndex(3);

    expect(presenter.selectedModuleIndex, 3);
  });
}
