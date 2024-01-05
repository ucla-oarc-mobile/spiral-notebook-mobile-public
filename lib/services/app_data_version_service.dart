import 'package:spiral_notebook/api/eqis_api.dart';

const dataVersionUpdateMessage = "App layout updates and general improvements.";

class AppDataVersionService {
  final _version = EqisAPI();

  bool versionConflicts() => _version.appDataVersionConflicts;
  void overwriteVersionCache() => _version.overwriteAppDataVersionCache();


}