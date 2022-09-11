import 'package:shared_preferences/shared_preferences.dart';

class Item<T> {
  String key;
  T value;

  Item({required this.key, required this.value});
}

class SpTools<T> {
  List<Item> items;

  SpTools(this.items) {
    sharedPrefInit(items);
  }

  void setValue(String key, int value) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    int V = value;
    String K = key;
    prefs.setInt(K, V);
  }

  void setBool(String key, bool value) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    bool V = value;
    String K = key;
    prefs.setBool(K, V);
  }

  void sharedPrefInit(List<Item> items) async {
    for (int i = 0; i < items.length; i++) {
      String K = items.elementAt(i).key;
      T V = items.elementAt(i).value;
      try {
        /// Checks if shared preference exist
        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        final SharedPreferences prefs = await _prefs;
        if (V is String) {
          prefs.getString(K);
        } else if (V is int) {
          prefs.getInt(K);
        } else if (V is double) {
          prefs.getDouble(K);
        } else if (V is bool) {
          prefs.getBool(K);
        }
        print("(I) already exists");
      } catch (err) {
        print("(I) Error caught: $err");

        Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
        final SharedPreferences prefs = await _prefs;
        if (V is String) {
          prefs.setString(K, V);
        } else if (V is int) {
          prefs.setInt(K, V);
        } else if (V is double) {
          prefs.setDouble(K, V);
        } else if (V is bool) {
          prefs.setBool(K, V);
        }
      }
    }
  }

//getters
  Future<String> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String if not null, if null return ""
    String stringValue =
        prefs.getString(key) == null ? "" : prefs.getString(key)!;
    return stringValue;
  }

  Future<bool> getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(key) == null ? false : prefs.getBool(key)!;
    return boolValue;
  }

  Future<int> getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key) == null ? 0 : prefs.getInt(key)!;
    return intValue;
  }

  Future<int> increment(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key) == null ? 0 : prefs.getInt(key)!;
    intValue++;
    setValue(key, intValue);
    return getIntValuesSF(key);
  }

  void inc(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setValue(key, prefs.getInt(key)! + 1);
  }

  Future<double> getDoubleValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue =
        prefs.getDouble(key) == null ? 0.0 : prefs.getDouble(key)!;
    return doubleValue;
  }

  checkKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
