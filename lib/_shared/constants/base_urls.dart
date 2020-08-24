class BaseUrls {
  //Sub domains
  static const String _CORE = 'core';
  static const String _TASK_SUB_DOMAIN = 'task';
  static const String _HR_SUB_DOMAIN = 'task';

  //Versions
  static const String _VERSION_2_PATH = 'v2';
  static const String _VERSION_3_PATH = 'v3';

  //Environments
  static const String _PRODUCTION = '';
  static const String _STAGING = 'stagingapi';
  static const String _TEST = 'testapi';

  static String generateUrl({String subDomain, String environment, String version}) {
    return 'https://$subDomain.${environment}api.wallpostsoftware.com/api/$version';
  }

  static const String _ENVIRONMENT = _PRODUCTION;

  static String baseUrlV2() {
    return BaseUrls.generateUrl(
      subDomain: _CORE,
      environment: _ENVIRONMENT,
      version: _VERSION_2_PATH,
    );
  }

  static String hrUrlV2() {
    return BaseUrls.generateUrl(
      subDomain: _HR_SUB_DOMAIN,
      environment: _ENVIRONMENT,
      version: _VERSION_2_PATH,
    );
  }
}
