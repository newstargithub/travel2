import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_amap_location_plugin/flutter_amap_location_plugin.dart';
import 'package:roll_demo/bean/IWeather.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/repository/WeatherRepository.dart';
import 'package:roll_demo/net/storage_manager.dart';

/// 本地化语言,设置
class LocaleModel extends ChangeNotifier {

  static const localeValueList = ['', 'zh-CN', 'en'];

  int _localeIndex = 0;

  String kLocaleIndex = "kLocaleIndex";
  String kShowBottomNavigationBar = "kShowBottomNavigationBar";

  AMapLocation _location;

  IWeather _weather;

  bool _showBottomNavigationBar;

  LocaleModel() {
    //?? value 为空时，返回默认值value
    _localeIndex = StorageManager.sharedPreferences.getInt(kLocaleIndex) ?? 0;
    _showBottomNavigationBar = StorageManager.sharedPreferences.getBool(kShowBottomNavigationBar) ?? true;
  }

  int get localeIndex => _localeIndex;

  bool get showBottomNavigationBar => _showBottomNavigationBar;

  Locale get locale {
    if (_localeIndex > 0) {
      var value = localeValueList[_localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
    }
    //跟随系统
    return null;
  }

  switchLocale(int index) {
    _localeIndex = index;
    StorageManager.sharedPreferences.setInt(kLocaleIndex, index);
    notifyListeners();
  }

  /// 显示隐藏底部导航栏
  switchBottomNavigationBar() {
    _showBottomNavigationBar = !_showBottomNavigationBar;
    StorageManager.sharedPreferences.setBool(kShowBottomNavigationBar, _showBottomNavigationBar);
    notifyListeners();
  }

  static String localeName(index, context) {
    switch (index) {
      case 0:
        return S.of(context).autoBySystem;
      case 1:
        return '中文';
      case 2:
        return 'English';
      default:
        return '';
    }
  }

  /// 获取定位
  Future<AMapLocation> get location async {
    if (_location == null) {
      _location = await getLocation();
    }
    return _location;
  }

  /// 获取天气
  Future<IWeather> get weather async {
    if (_weather == null) {
      var mapLocation = await location;
      _weather = await getWeatherByCity(city: mapLocation?.city);
    }
    debugPrint(weather.toString());
    return _weather;
  }

  ///获取定位 location = 114.050626,22.600083，广东省深圳市龙华区民富路701靠近民乐立交
  Future<AMapLocation> getLocation() async {
    AMapLocation location =
    await FlutterAmapLocationPlugin.getLocation(needAddress: true);
    print("location = ${location.longitude},${location.latitude}，${location.address}");
    return location;
  }

  Future<IWeather> getWeatherByCity({String city}) async {
    return await WeatherRepository.fetchWeatherByCity(city);
  }

}