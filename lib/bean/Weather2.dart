import 'IWeather.dart';

class Weather2 implements IWeather {
  String city;
  String fengxiang;
  String shidu;
  String sunrise1;
  String sunset1;
  String updatetime;
  String wendu;
//  FengliBean fengli;
  ForecastBean forecast;
  YesterdayBean yesterday;
  ZhishusBean zhishus;

  Weather2(
      {this.city,
      this.fengxiang,
      this.shidu,
      this.sunrise1,
      this.sunset1,
      this.updatetime,
      this.wendu,
//      this.fengli,
      this.forecast,
      this.yesterday,
      this.zhishus});

  Weather2.fromJson(Map<String, dynamic> json) {
    this.city = json['city'];
    this.fengxiang = json['fengxiang'];
    this.shidu = json['shidu'];
    this.sunrise1 = json['sunrise_1'];
    this.sunset1 = json['sunset_1'];
    this.updatetime = json['updatetime'];
    this.wendu = json['wendu'];
//    this.fengli =
//        json['fengli'] != null ? FengliBean.fromJson(json['fengli']) : null;
    this.forecast = json['forecast'] != null
        ? ForecastBean.fromJson(json['forecast'])
        : null;
    this.yesterday = json['yesterday'] != null
        ? YesterdayBean.fromJson(json['yesterday'])
        : null;
    this.zhishus =
        json['zhishus'] != null ? ZhishusBean.fromJson(json['zhishus']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['fengxiang'] = this.fengxiang;
    data['shidu'] = this.shidu;
    data['sunrise_1'] = this.sunrise1;
    data['sunset_1'] = this.sunset1;
    data['updatetime'] = this.updatetime;
    data['wendu'] = this.wendu;
//    if (this.fengli != null) {
//      data['fengli'] = this.fengli.toJson();
//    }
    if (this.forecast != null) {
      data['forecast'] = this.forecast.toJson();
    }
    if (this.yesterday != null) {
      data['yesterday'] = this.yesterday.toJson();
    }
    if (this.zhishus != null) {
      data['zhishus'] = this.zhishus.toJson();
    }
    return data;
  }

  @override
  String get ganmao {
    var list = zhishus.zhishu;
    for (ZhishuListBean item in list) {
      if (item.name.contains("穿衣")) {
        return item.detail;
      }
    }
    return null;
  }

  @override
  String get date {
    return forecast.weather[0].date;
  }

  @override
  String get high {
    return forecast.weather[0].high;
  }

  @override
  String get low {
    return forecast.weather[0].low;
  }

  @override
  String get type {
    return forecast.weather[0].day.type;
  }

  @override
  List<IZhishu> get zhishuList => zhishus.zhishu;

  @override
  List<IForecast> get forecastList => forecast.weather;
}

///风力
class FengliBean {
  FengliBean();

  FengliBean.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

//天气预报数据
class ForecastBean {
  List<WeatherListBean> weather;

  ForecastBean({this.weather});

  ForecastBean.fromJson(Map<String, dynamic> json) {
    this.weather = (json['weather'] as List) != null
        ? (json['weather'] as List)
            .map((i) => WeatherListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weather'] = this.weather != null
        ? this.weather.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class YesterdayBean {
  String date1;
  String high1;
  String low1;
  YesterdayWeatherTypeBean day1;
  YesterdayWeatherTypeBean night1;

  YesterdayBean({this.date1, this.high1, this.low1, this.day1, this.night1});

  YesterdayBean.fromJson(Map<String, dynamic> json) {
    this.date1 = json['date_1'];
    this.high1 = json['high_1'];
    this.low1 = json['low_1'];
    this.day1 = json['day_1'] != null
        ? YesterdayWeatherTypeBean.fromJson(json['day_1'])
        : null;
    this.night1 = json['night_1'] != null
        ? YesterdayWeatherTypeBean.fromJson(json['night_1'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_1'] = this.date1;
    data['high_1'] = this.high1;
    data['low_1'] = this.low1;
    if (this.day1 != null) {
      data['day_1'] = this.day1.toJson();
    }
    if (this.night1 != null) {
      data['night_1'] = this.night1.toJson();
    }
    return data;
  }
}

class ZhishusBean {
  List<ZhishuListBean> zhishu;

  ZhishusBean({this.zhishu});

  ZhishusBean.fromJson(Map<String, dynamic> json) {
    this.zhishu = (json['zhishu'] as List) != null
        ? (json['zhishu'] as List)
            .map((i) => ZhishuListBean.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zhishu'] = this.zhishu != null
        ? this.zhishu.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

///指数
class ZhishuListBean implements IZhishu {
  String detail;
  String name;
  String value;

  ZhishuListBean({this.detail, this.name, this.value});

  ZhishuListBean.fromJson(Map<String, dynamic> json) {
    this.detail = json['detail'];
    this.name = json['name'];
    this.value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detail'] = this.detail;
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class YesterdayWeatherTypeBean {
  String fx1;
  String type1;
  FengliBean fl1;

  YesterdayWeatherTypeBean({this.fx1, this.type1, this.fl1});

  YesterdayWeatherTypeBean.fromJson(Map<String, dynamic> json) {
    this.fx1 = json['fx_1'];
    this.type1 = json['type_1'];
    this.fl1 = json['fl_1'] != null ? FengliBean.fromJson(json['fl_1']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fx_1'] = this.fx1;
    data['type_1'] = this.type1;
    if (this.fl1 != null) {
      data['fl_1'] = this.fl1.toJson();
    }
    return data;
  }
}

///一天的天气数据 日期，温度，天气类型
class WeatherListBean extends IForecast {
  String date;
  String high;
  String low;
  WeatherTypeBean day;
  WeatherTypeBean night;

  String get formatHigh {
    RegExp exp = new RegExp(r"(\d+)℃");
    Iterable<RegExpMatch> matches = exp.allMatches(high);
    if (matches.isNotEmpty) {
      return matches.first.group(0);
    }
    return high;
  }

  String get formatLow {
    RegExp exp = new RegExp(r"(\d+)℃");
    Iterable<RegExpMatch> matches = exp.allMatches(low);
    if (matches.isNotEmpty) {
      return matches.first.group(0);
    }
    return low;
  }

  WeatherListBean({this.date, this.high, this.low, this.day, this.night});

  WeatherListBean.fromJson(Map<String, dynamic> json) {
    this.date = json['date'];
    this.high = json['high'];
    this.low = json['low'];
    this.day =
        json['day'] != null ? WeatherTypeBean.fromJson(json['day']) : null;
    this.night =
        json['night'] != null ? WeatherTypeBean.fromJson(json['night']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['high'] = this.high;
    data['low'] = this.low;
    if (this.day != null) {
      data['day'] = this.day.toJson();
    }
    if (this.night != null) {
      data['night'] = this.night.toJson();
    }
    return data;
  }

  @override
  String get type => day.type;
}

///天气类型: 类型，风向，风力
class WeatherTypeBean {
  String fengxiang;
  String type;
  FengliBean fengli;

  WeatherTypeBean({this.fengxiang, this.type, this.fengli});

  WeatherTypeBean.fromJson(Map<String, dynamic> json) {
    this.fengxiang = json['fengxiang'];
    this.type = json['type'];
    this.fengli =
        json['fengli'] != null ? FengliBean.fromJson(json['fengli']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fengxiang'] = this.fengxiang;
    data['type'] = this.type;
    if (this.fengli != null) {
      data['fengli'] = this.fengli.toJson();
    }
    return data;
  }
}
