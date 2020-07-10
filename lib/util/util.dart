

import 'dart:collection';

class Utils {
  ///方法参数里的{}为可选参数
  static String getImgPath(String name, {String format: 'png'}) {
    return "assets/image/$name.$format";
  }

  ///方法参数里的{}为可选参数
  static String getSvgPath(String name, {String format: 'svg'}) {
    return "assets/svgs/$name.$format";
  }

  static String getWeatherTypeIcon(String name) {
    final Map map = Map<String, String>();
    map["晴"] = "fine";
    map["雨"] = "rain";
    map["阴"] = "overcast";
    map["云"] = "cloudy";
    map["雪"] = "snow";
    for(MapEntry<String, String> entry in map.entries) {
      if(name.contains(entry.key)) {
        return entry.value;
      }
    }
    return "snow";
  }









}