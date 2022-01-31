import 'package:wallpost/_shared/constants/base_urls.dart';

class PermissionsUrls {
  static String getRequestItemsUrl(String companyId) {
    return '${BaseUrls.hrUrlV3()}/$companyId/request/items';
  }
}
