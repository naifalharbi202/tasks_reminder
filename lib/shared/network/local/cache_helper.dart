import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    return sharedPreferences = await SharedPreferences.getInstance();
  }

  // Save data method includes this. You can get rid of this setBoolean in next project
  static Future<bool> setBoolean(key, value) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData(key) {
    return sharedPreferences!.get(key);
  }

  // This method to make saving in shared prefrences easier
  static Future<bool> saveData({
    required key,
    required value,
  }) async {
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  // This method to make saving in shared prefrences easier
  static Future<bool> saveListData({
    required key,
    required List<String> value,
  }) async {
    return await sharedPreferences!.setStringList(key, value);
  }

  static Future<bool> removeData(key) async {
    return await sharedPreferences!.remove(key);
  }
}
