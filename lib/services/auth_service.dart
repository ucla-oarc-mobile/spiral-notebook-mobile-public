import 'package:spiral_notebook/api/eqis_api.dart';


class AuthService {
  final _auth = EqisAPI();

  Future<dynamic> authorizedViaPassword({String username = '', String password = ''}) async {
    final dynamic loginResult = await _auth.authPassword(
      username: username,
      password: password,
    );

    final Map<String, dynamic>? userData = loginResult['user'];

    assert(userData != null);

    return userData;
  }

  Future<dynamic> fetchUserDetails() async {
    final userDetails = await _auth.fetchUserDetails();
    return userDetails;
  }

  Future<dynamic> refreshLoginToken() async {
    final refreshToken = await _auth.refreshLoginToken();
    return refreshToken;
  }

  Future<bool> isLoggedIn() async {
    // provide passthru for isLoggedIn, protect widgets from API
    final bool isLoggedIn = await _auth.isLoggedIn();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    // TODO: Add user cleanup events
    await _auth.unregisterPushToken();
    final bool logoutSuccessful = _auth.clearLoginToken();
    return logoutSuccessful;
  }
}