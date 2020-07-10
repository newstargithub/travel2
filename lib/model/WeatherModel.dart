import 'package:flutter_amap_location_plugin/flutter_amap_location_plugin.dart';
import 'package:roll_demo/bean/IWeather.dart';
import 'package:roll_demo/model/repository/WeatherRepository.dart';

import 'ViewStateListModel.dart';

//天气Model
class WeatherModel extends ViewStateModel {
  String _city;
  IWeather _weather;

  var DEFAULT_CITY = "北京";

  String get city => _city;
  IWeather get weather => _weather;

  initData({String city}) async {
    setBusy(true);
    try {
      if(city == null) {
        var location = await getLocation();
        _city = location != null && location.city != null ? location.city : DEFAULT_CITY;
      }
      _weather = await WeatherRepository.fetchWeatherByCity(_city);
      setBusy(false);
      notifyListeners();
    } catch (e, s) {
      handleCatch(e, s);
    }
  }

  ///获取定位 location = 114.050626,22.600083，广东省深圳市龙华区民富路701靠近民乐立交
  Future<AMapLocation> getLocation() async {
    AMapLocation location =
    await FlutterAmapLocationPlugin.getLocation(needAddress: true);
    print("location = ${location.longitude},${location.latitude}，${location.address}");
    return location;
  }
}
