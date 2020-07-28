import 'package:flutter/material.dart';
import 'package:flutter_amap_location_plugin/amap_location_option.dart';
import 'package:flutter_amap_location_plugin/flutter_amap_location_plugin.dart';
import 'package:roll_demo/bean/IWeather.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/WeatherModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/colors.dart';

import 'ViewStateWidget.dart';

class WeatherFloatWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherFloatState();
  }
}

class _WeatherFloatState extends State<WeatherFloatWidget> {
  @override
  void initState() {
    super.initState();
    //启动客户端,这里设置ios端的精度小一点
    FlutterAmapLocationPlugin.startup(
      AMapLocationOption(
        iosOption: IosAMapLocationOption(
          locatingWithReGeocode: true,
          desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //注意这里关闭
    FlutterAmapLocationPlugin.shutdown();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ProviderWidget<WeatherModel>(
          model: WeatherModel(),
          onModelReady: (model) => model.initData(),
          builder: (context, WeatherModel model, child) {
            if (model.loading) {
              return ViewStateLoadingWidget();
            } else if (model.error) {
              return FlatButton.icon(
                icon: Icon(Icons.refresh),
                label: Text(S.of(context).retry),
                onPressed: model.initData,
              );
            }
            return _buildWeatherContent(model.weather);
          },
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colours.pop_bg,
            boxShadow: [ //卡片阴影
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0
              )
            ]
        ),
      );
  }

  //展示天气控件
  Widget _buildWeatherContent(IWeather weather) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(weather.type),
          Text("${weather.wendu}℃"),
          Text(weather.city)
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
          /*gradient: RadialGradient( //背景径向渐变
              colors: [Colors.red, Colors.orange],
              center: Alignment.topLeft,
              radius: .98
          ),*/
          borderRadius: BorderRadius.circular(8),
          color: Colours.pop_bg,
          boxShadow: [ //卡片阴影
            BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0
            )
          ]
      ),
    );
  }
}
