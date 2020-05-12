import 'package:shared_preferences/shared_preferences.dart';

Future<String> getQr() async {
  final _prefs = await SharedPreferences.getInstance();
  return _prefs.getString('qr') ?? '';
}

Future<void> setQr(String value) async {
  final _prefs = await SharedPreferences.getInstance();
  _prefs.setString('qr', value);
}
