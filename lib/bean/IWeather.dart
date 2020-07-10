

///天气
abstract class IWeather {

  String get city;

  String get wendu;

  String get date;

  String get type;

  String get high;

  String get low;

  String get ganmao;

  String get fengxiang;

  String get shidu;

  ///发布时间
  String get updatetime;

  ///指数列表
  List<IZhishu> get zhishuList;

  ///预测列表
  List<IForecast> get forecastList;
}

///指数
abstract class IZhishu {
  String get detail;
  String get name;
  String get value;
}

///预报
abstract class IForecast {
  String get date;
  String get type;
  String get high;
  String get low;
  String get formatHigh;
  String get formatLow;
}