import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<int> getPrefInt(String key) async { //digunakan untuk mengambil value bertipe data integer
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  Future<String> getPrefString(String key) async { //digunakan untuk mengambil value bertipe data string
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> getPrefBool(String key) async { //digunakan untuk mengambil value bertipe data boolean
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  void setPrefInt(String key, int value) async { //digunakan untuk menyimpan value bertipe data integer
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  void setPrefString(String key, String value) async { //digunakan untuk menyimpan value bertipe data string
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  void setPrefBool(String key, bool value) async { //digunakan untuk menyimpan value bertipe data boolean
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}