// ignore_for_file: unused_field

class BaseUrls {
  //Sub domains
  static const String _CORE = 'core';
  static const String _HR_SUB_DOMAIN = 'hr';
  static const String _RESTAURANT_SUB_DOMAIN = 'restaurant';
  static const String _MISC_SUB_DOMAIN = 'misc';
  static const String _FINANCE_SUB_DOMAIN = 'finance';

  //Environments
  static const String _PRODUCTION = '';
  static const String _STAGING = 'staging';
  static const String _TEST = 'test';

  //Versions
  static const String _VERSION_1_PATH = 'v1';
  static const String _VERSION_2_PATH = 'v2';
  static const String _VERSION_3_PATH = 'v3';

  static String generateUrl({
    required String subDomain,
    required String environment,
    required String version,
  }) {
    return 'https://$subDomain.${environment}api.wallpostsoftware.com/api/$version';
  }

  static const String _ENVIRONMENT = _PRODUCTION;

  static String baseUrlV2() {
    return BaseUrls.generateUrl(subDomain: _CORE, environment: _ENVIRONMENT, version: _VERSION_2_PATH);
  }

  static String hrUrlV2() {
    return BaseUrls.generateUrl(subDomain: _HR_SUB_DOMAIN, environment: _ENVIRONMENT, version: _VERSION_2_PATH);
  }

  static String hrUrlV3() {
    return BaseUrls.generateUrl(subDomain: _HR_SUB_DOMAIN, environment: _ENVIRONMENT, version: _VERSION_3_PATH);
  }

  static String restaurantUrlV2() {
    return BaseUrls.generateUrl(subDomain: _RESTAURANT_SUB_DOMAIN, environment: _ENVIRONMENT, version: _VERSION_2_PATH);
  }

  static String miscUrlV2() {
    return BaseUrls.generateUrl(subDomain: _MISC_SUB_DOMAIN, environment: _ENVIRONMENT, version: _VERSION_2_PATH);
  }

  static String financeUrlV2() {
    return BaseUrls.generateUrl(subDomain: _FINANCE_SUB_DOMAIN, environment: _ENVIRONMENT, version: _VERSION_1_PATH);
  }
}
