  import 'package:shared_preferences/shared_preferences.dart';


class AppDataVersion {
  static String _appDataVersionStoreKey = 'appDataVersion';

  String _appDataVersion = '';

  String get version => _appDataVersion;

  AppDataVersion() {
    loadVersion();
  }

  void setVersion(String? version) {
    if (version == null) version = '';
    _appDataVersion = version;
    savePreferences();
  }

  savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_appDataVersionStoreKey, _appDataVersion);
  }

  loadVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appVersion = prefs.getString(_appDataVersionStoreKey);

    if (appVersion != null && appVersion != '') setVersion(appVersion);
    return appVersion;
  }
}