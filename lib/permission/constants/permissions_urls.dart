import 'package:wallpost/_shared/constants/base_urls.dart';

class PermissionsUrls {
  static String getRequestItems(String companyId) {
    return '${BaseUrls.hrUrlV2()}/$companyId/request/items';
  }
}
