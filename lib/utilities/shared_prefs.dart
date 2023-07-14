import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferencesUtil? _instance;
  late SharedPreferences _prefs;

  factory SharedPreferencesUtil() {
    if (_instance == null) {
      _instance = SharedPreferencesUtil._();
    }
    return _instance!;
  }

  SharedPreferencesUtil._();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }
}
