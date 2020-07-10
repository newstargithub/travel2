
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:roll_demo/util/image_util.dart';
import 'package:roll_demo/util/util.dart';
/// 天气图标
class WeatherTypeIcon extends StatelessWidget{
  final String type;

  WeatherTypeIcon(this.type);

  @override
  Widget build(BuildContext context) {
    var icon = Utils.getWeatherTypeIcon(type);
    return loadAssetImage(
      icon,
      width: 32,
      height: 32,
      fit: BoxFit.cover,
    );
  }
}

enum WeatherType {
  fine,
  rain,
  overcast,
  cloudy,
  snow
}