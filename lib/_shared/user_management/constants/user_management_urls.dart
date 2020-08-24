import 'package:wallpost/_shared/constants/base_urls.dart';

import 'get_user_roles_filters.dart';

class UserManagementUrls {
  static String getUserRolesUrl(GetUserRolesFilters filters) {
    return '${BaseUrls.baseUrlV2}/companies/${filters.companyId}/users/${filters.userId}';
  }
}
