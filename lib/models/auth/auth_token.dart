import 'package:shared_preferences/shared_preferences.dart';


class AuthToken {
  static String _tokenStoreKey = 'authToken';

  String _authToken = '';

  String get token => _authToken;

  AuthToken() {
    loadToken();
  }

  void setToken(String? token) {
    if (token == null) token = '';
    _authToken = token;
    savePreferences();
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenStoreKey, _authToken);
  }

  loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(_tokenStoreKey);

    if (authToken != null && authToken != '') setToken(authToken);
    return authToken;
  }
}