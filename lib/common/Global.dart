import 'dart:convert';

import 'package:roll_demo/bean/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局变量-Global类
/// 它主要管理APP的全局变量
class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  /// 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  ///初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
  }

  /// 持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}
