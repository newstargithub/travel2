import 'package:roll_demo/config/keys.dart';
import 'package:roll_demo/net/storage_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil{

  factory SpUtil() => _getInstance();

  static SpUtil get instance => _getInstance();
  static SpUtil _instance;


  SpUtil._internal() {
    //初始化
  }

  static SpUtil _getInstance() {
    if (_instance == null) {
      _instance = new SpUtil._internal();
    }
    return _instance;
  }


  static SharedPreferences getSharedPreferences () {
    return StorageManager.sharedPreferences;
  }

  static Future saveString (String key, String value) async{
    SharedPreferences prefs = getSharedPreferences();
    if(key == Keys.account){
      await prefs.setString(key, value);
      return;
    }
    String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setString(key + account, value);
  }

  static Future saveInt (String key, int value) async{
    SharedPreferences prefs = getSharedPreferences();
    String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setInt(key + account, value);
  }

  static Future saveDouble (String key, double value) async{
    SharedPreferences prefs = getSharedPreferences();
    String account = prefs.getString(Keys.account) ?? "default";
    await prefs.setDouble(key + account, value);
  }

  static Future putBool (String key, bool value) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    await prefs.setBool(key + account, value);
  }

  static Future saveStringList (String key, List<String> list) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    await prefs.setStringList(key + account, list);
  }

  static Future<bool> readAndSaveList(String key, String data) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key + account) ?? [];
    if(strings.length >= 10) return false;
    strings.add(data);
    await prefs.setStringList(key + account, strings);
    return true;
  }

  static void readAndExchangeList(String key, String data, int index) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key + account) ?? [];
    strings[index] = data;
    await prefs.setStringList(key + account, strings);
  }

  static void readAndRemoveList(String key,int index) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key + account) ?? [];
    strings.removeAt(index);
    await prefs.setStringList(key + account, strings);
  }


  //-----------------------------------------------------get----------------------------------------------------


  static Future<String> getString (String key, {String defValue}) async{
    SharedPreferences prefs = getSharedPreferences();
    if(key == Keys.account){
      return prefs.getString(key);
    }
    String account =  prefs.getString(Keys.account) ?? "default";
    return prefs.getString(key + account)?? defValue;
  }

  static Future<int> getInt (String key) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    return prefs.getInt(key + account);
  }

  static Future<double> getDouble (String key) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    return prefs.getDouble(key + account);
  }

  static bool getBool (String key, {bool defValue = false}) {
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    return prefs.getBool(key + account)??defValue;
  }

  static Future<List<String>> getStringList(String key) async{
    SharedPreferences prefs = getSharedPreferences();
    String account =  prefs.getString(Keys.account) ?? "default";
    return prefs.getStringList(key + account);
  }

  static Future<List<String>> readList(String key) async{
    SharedPreferences prefs = getSharedPreferences();
    String account = prefs.getString(Keys.account) ?? "default";
    List<String> strings = prefs.getStringList(key + account) ?? [];
    return strings;
  }

  static void remove(String key) {
    SharedPreferences prefs = getSharedPreferences();
    String account = prefs.getString(Keys.account) ?? "default";
    prefs.remove(key + account);
  }

}