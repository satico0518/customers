import 'package:customers/src/pages/login-page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceAuth {
  static final PreferenceAuth _instance = new PreferenceAuth._internal();

  factory PreferenceAuth() {
    return _instance;
  }

  PreferenceAuth._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  bool get isUserLoggedIn {
    return _prefs.getBool('userLogged') ?? false;
  }

  set isUserLoggedIn(bool value) {
    _prefs.setBool('userLogged', value);
  }

  bool get isShopLoggedIn {
    return _prefs.getBool('shopLogged') ?? false;
  }

  set isShopLoggedIn(bool value) {
    _prefs.setBool('shopLogged', value);
  }

  String get initialRoute {
    return _prefs.getString('initialRoute') ?? LoginPage.routeName;
  }

  set initialRoute(String value) {
    _prefs.setString('initialRoute', value);
  }

  String get currentBranchDocId {
    return _prefs.getString('currBranch') ?? LoginPage.routeName;
  }

  set currentBranchDocId(String value) {
    _prefs.setString('currBranch', value);
  }
}
