import 'package:customers/src/models/shop-branch.model.dart';
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

  ShopBranchModel get currentBranch {
    return ShopBranchModel(
      shopDocumentId: _prefs.getString('shopDocumentId'), 
      branchDocumentId: _prefs.getString('branchDocumentId'), 
      branchName: _prefs.getString('branchName'), 
      branchAddress: _prefs.getString('branchAddress'), 
      branchMemo: _prefs.getString('branchMemo'), 
      capacity: _prefs.getInt('capacity'), 
      maxCapacity: _prefs.getInt('maxCapacity'), 
    );
  }

  set currentBranch(ShopBranchModel branch) {
    _prefs.setString('shopDocumentId', branch.shopDocumentId);
    _prefs.setString('branchDocumentId', branch.branchDocumentId);
    _prefs.setString('branchName', branch.branchName);
    _prefs.setString('branchAddress', branch.branchAddress);
    _prefs.setString('branchMemo', branch.branchMemo);
    _prefs.setInt('capacity', branch.capacity);
    _prefs.setInt('maxCapacity', branch.maxCapacity);
  }
}
