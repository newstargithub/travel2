//天气页面
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:provider/provider.dart';
import 'package:roll_demo/bean/IWeather.dart';
import 'package:roll_demo/bean/Weather.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/WeatherModel.dart';
import 'package:roll_demo/provider/ProviderWidget.dart';
import 'package:roll_demo/res/colors.dart';
import 'package:roll_demo/res/dimens.dart';
import 'package:roll_demo/util/constant.dart';
import 'package:roll_demo/util/route.dart';
import 'package:roll_demo/widget/ViewStateWidget.dart';
import 'package:roll_demo/res/styles.dart';
import 'package:roll_demo/widget/WeatherTypeIcon.dart';

///http://wthrcdn.etouch.cn/weather_mini?city=北京
//通过城市名字获得天气数据，json数据
//http://wthrcdn.etouch.cn/weather_mini?citykey=101010100
//通过城市id获得天气数据，json数据
//http://www.weather.com.cn/data/zs/101010100.html
class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ProviderWidget<WeatherModel>(
      model: WeatherModel(),
      onModelReady: (model) => model.initData(),
      builder: (context, WeatherModel model, child) {
        return _buildContent(model);
      },
    )));
  }

  Widget _buildWeatherContent(IWeather weather) {
    var zhishuList = weather.zhishuList;
    var forecastList = weather.forecastList;
    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(10.0),
              sliver: new SliverToBoxAdapter(
                child: Container(
                  height: 180,
                  child: Column(
                    children: <Widget>[
                      Gaps.vGap4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(weather.wendu, style: TextStyles.textMain48),
                          Text("℃", style: TextStyles.textMain18),
                        ],
                      ),
                      Gaps.vGap2,
                      Text(weather.date, style: TextStyles.textMiddle),
                      Gaps.vGap2,
                      Text(weather.type, style: TextStyles.textLarge),
                      Gaps.vGap8,
                      Text(
                          S.of(context).today +
                              " ${weather.high}/${weather.low}",
                          style: TextStyles.textMiddle),
                      Gaps.vGap4,
                      Text(weather.ganmao, style: TextStyles.textSmall),
                    ],
                  ),
                ),
              ),
            ),
            //AppBar，包含一个导航栏
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: new SliverGrid(
                //Grid 实现了一个横轴子元素为固定最大长度的layout算法
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 80, //子元素在横轴上的最大长度
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 1.5),
                delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var zhishu = zhishuList[index];
                    //创建子widget
                    return Column(
                      children: <Widget>[
                        Text(zhishu.name),
                        Text(zhishu.value),
                      ],
                    );
                  },
                  childCount: zhishuList.length,
                ),
              ),
            ),
            //List
            new SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                var forecast = forecastList[index];
                //创建列表项
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        child: Text(forecast.date),
                      ),
                      WeatherTypeIcon(forecast.type),
                      Positioned(
                        right: 0,
                        child: Text(forecast.formatLow),
                      ),
                    ],
                  ),
                  /*child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(forecast.date),
                              WeatherTypeIcon(forecast.type),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(forecast.formatHigh),
                              Gaps.hGap15,
                              Text(forecast.formatLow),
                            ],
                          ),
                        ],
                      ),*/
                );
              }, childCount: forecastList.length),
            ),
          ],
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          alignment: Alignment.centerLeft,
          child: InkWell(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Theme.of(context).accentColor,
                  size: 24,
                ),
                Text(weather.city, style: TextStyles.textLarge)
              ],
            ),
            onTap: _onTapSelectAddress,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(WeatherModel model) {
    if (model.loading) {
      return ViewStateLoadingWidget();
    } else if (model.error) {
      return ViewStateWidget(
          message: model.errorMessage, onPressed: model.initData);
    }
    return _buildWeatherContent(model.weather);
  }

  /// 选择地址
  void _onTapSelectAddress() {
    debugPrint("选择地址");
    NavigatorUtils.pushResult(context, ADDRESS_SELECT_PAGE, (result) {
      PoiSearch model = result;
      WeatherModel weatherModel = Provider.of<WeatherModel>(context);
      String address = model.provinceName +
          " " +
          model.cityName +
          " " +
          model.adName +
          " " +
          model.title;
      debugPrint(address);
      weatherModel.initData(city: model.cityName);
    });
  }
}
