import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {
  late final SharedPreferences _instance;

  Future<void> initialize() async {
    _instance = await SharedPreferences.getInstance();
  }

  bool? getBool(String key) {
    return _instance.getBool(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _instance.setBool(key, value);
  }

  int? getInt(String key) {
    return _instance.getInt(key);
  }

  Future<void> setInt(String key, int value) async {
    await _instance.setInt(key, value);
  }

  String? getStr(String key) {
    return _instance.getString(key);
  }

  Future<void> setStr(String key, String value) async {
    await _instance.setString(key, value);
  }

  double? getDouble(String key) {
    return _instance.getDouble(key);
  }

  Future<void> setDouble(String key, double value) async {
    await _instance.setDouble(key, value);
  }
}
