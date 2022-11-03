import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_wp_core/company_management/entities/module.dart';

void main() {
  test("only the desired modules are added and are in the correct order", () {
    expect(Module.values, [
      Module.Finance,
      Module.Crm,
      Module.Restaurant,
      Module.Retail,
      Module.Hr,
    ]);
  });
}
