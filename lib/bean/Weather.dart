class Weather {
  String city;//城市
  String ganmao;//感冒指数
  String wendu;//温度
  YesterdayBean yesterday;//昨天
  List<Forecast> forecast;//预报

  Weather({this.city, this.ganmao, this.wendu, this.yesterday, this.forecast});

  Weather.fromJson(Map<String, dynamic> json) {
    this.city = json['city'];
    this.ganmao = json['ganmao'];
    this.wendu = json['wendu'];
    this.yesterday = json['yesterday'] != null
        ? YesterdayBean.fromJson(json['yesterday'])
        : null;
    this.forecast = (json['forecast'] as List) != null
        ? (json['forecast'] as List)
            .map((i) => Forecast.fromJson(i))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['ganmao'] = this.ganmao;
    data['wendu'] = this.wendu;
    if (this.yesterday != null) {
      data['yesterday'] = this.yesterday.toJson();
    }
    data['forecast'] = this.forecast != null
        ? this.forecast.map((i) => i.toJson()).toList()
        : null;
    return data;
  }
}

class YesterdayBean {
  String date;
  String high;
  String fx;
  String low;
  String fl;
  String type;

  YesterdayBean({this.date, this.high, this.fx, this.low, this.fl, this.type});

  YesterdayBean.fromJson(Map<String, dynamic> json) {
    this.date = json['date'];
    this.high = json['high'];
    this.fx = json['fx'];
    this.low = json['low'];
    this.fl = json['fl'];
    this.type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['high'] = this.high;
    data['fx'] = this.fx;
    data['low'] = this.low;
    data['fl'] = this.fl;
    data['type'] = this.type;
    return data;
  }
}

class Forecast {
  String date;//25日星期五
  String high;//高温 15℃
  String fengli;//<![CDATA[<3级]]>
  String low;//低温 3℃
  String fengxiang;//东北风
  String type;//晴

  Forecast(
      {this.date, this.high, this.fengli, this.low, this.fengxiang, this.type});

  Forecast.fromJson(Map<String, dynamic> json) {
    this.date = json['date'];
    this.high = json['high'];
    this.fengli = json['fengli'];
    this.low = json['low'];
    this.fengxiang = json['fengxiang'];
    this.type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['high'] = this.high;
    data['fengli'] = this.fengli;
    data['low'] = this.low;
    data['fengxiang'] = this.fengxiang;
    data['type'] = this.type;
    return data;
  }
}
