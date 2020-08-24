class BaseUrls {
  //Sub domains
  static const String _CORE = 'core';
  static const String _TASK_SUB_DOMAIN = 'task';

  //Versions
  static const String _VERSION_2_PATH = 'v2';
  static const String _VERSION_3_PATH = 'v3';

  //Environments
  static const String _PRODUCTION = '';
  static const String _STAGING = 'stagingapi';
  static const String _TEST = 'testapi';

  static String generateUrl(String subDomain, String environment, String version) {
    return 'https://$subDomain.${environment}api.wallpostsoftware.com/api/$version';
  }

  static const String _ENVIRONMENT = _PRODUCTION;

  static String baseUrlV2() {
    return BaseUrls.generateUrl(_CORE, _ENVIRONMENT, _VERSION_2_PATH);
  }
}
