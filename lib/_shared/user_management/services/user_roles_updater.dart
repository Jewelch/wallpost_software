import 'package:wallpost/_shared/user_management/constants/get_user_roles_filters.dart';
import 'package:wallpost/_shared/user_management/constants/user_management_urls.dart';
import 'package:wallpost/_shared/user_management/entities/user_roles.dart';
import 'package:wallpost/_shared/user_management/repositories/user_repository.dart';
import 'package:wallpost/_shared/wpapi/wp_api.dart';

class UserRolesUpdater {
  final UserRepository _userRepository;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;

  UserRolesUpdater()
      : _userRepository = UserRepository(),
        _networkAdapter = WPAPI();

  UserRolesUpdater.initWith(this._userRepository, this._networkAdapter);

  Future<void> updateRoles() async {
    var currentUser = _userRepository.getCurrentUser();
    GetUserRolesFilters filters = GetUserRolesFilters();
    filters.companyId = currentUser.companyId;
    filters.userId = currentUser.userId;

    var url = UserManagementUrls.getUserRolesUrl(filters);
    var apiRequest = APIRequest(url);
    isLoading = true;

    var apiResponse = await _networkAdapter.get(apiRequest);
    isLoading = false;
    return _processResponse(apiResponse);
  }

  void _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var userRoles = UserRoles.fromJson(responseMap);
      var user = _userRepository.getCurrentUser();
      user.updateRoles(userRoles);
      _userRepository.saveNewCurrentUser(user);
      return null;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
