// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesManager {
//   SharedPreferences? sharedPreferences;
//   SharedPreferencesManager({required this.sharedPreferences});
//   Future? putString(String key, String value) => sharedPreferences?.setString(key, value);
//   String? getString(String key) => sharedPreferences?.getString(key);
//   Future<bool>? putBool(String key, bool value) => sharedPreferences?.setBool(key, value);
//   bool? getBool(String key) => sharedPreferences?.getBool(key);
//   void removeKey(String key) => sharedPreferences?.remove(key);
// }

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferences? sharedPreferences;
  SharedPreferencesManager({required this.sharedPreferences});
  Future? putString(String key, String value) => sharedPreferences?.setString(key, value);
  String? getString(String key) => sharedPreferences?.getString(key);
  Future<bool>? putBool(String key, bool value) => sharedPreferences?.setBool(key, value);
  bool? getBool(String key) => sharedPreferences?.getBool(key);
  void removeKey(String key) => sharedPreferences?.remove(key);
}
