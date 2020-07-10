import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/IWeather.dart';
import 'package:roll_demo/bean/RespData.dart';
import 'package:roll_demo/bean/Weather.dart';
import 'package:roll_demo/bean/Weather2.dart';
import 'package:roll_demo/net/HttpBuilder.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';

class WeatherRepository {
  static String BASE_URL = "http://wthrcdn.etouch.cn/";

  static Dio shttp = HttpBuilder().baseUrl(BASE_URL).build();

  ///通过城市id获得天气数据，xml文件数据
  ///http://wthrcdn.etouch.cn/WeatherApi?citykey=101010100
  static Future<IWeather> fetchWeather() async {
    Dio shttp = HttpBuilder().baseUrl(BASE_URL).converter((data){
      // Create a client transformer
      final Xml2Json myTransformer = Xml2Json();
      // Parse a simple XML string
      myTransformer.parse(data);
      var json;
      // Transform to JSON using Parker
      json = myTransformer.toParker();
      print('Parker');
      print('');
      print(json);
      var map = jsonDecode(json);
      var respData = RespData(errorCode: 0, data: map["resp"]);
      return respData;
    }).build();
    var citykey = "101010100";
    var response = await shttp.get('WeatherApi?citykey=$citykey');
    return Weather2.fromJson(response.data);
  }

  ///通过城市id获得天气数据，xml文件数据
  ///http://wthrcdn.etouch.cn/WeatherApi?city=北京
  static Future<IWeather> fetchWeatherByCity(city) async {
    Dio shttp = HttpBuilder().baseUrl(BASE_URL).converter((data){
      // Create a client transformer
      final Xml2Json myTransformer = Xml2Json();
      // Parse a simple XML string
      myTransformer.parse(data);
      var json;
      // Transform to JSON using Parker
      json = myTransformer.toParker();
      print(json);
      var map = jsonDecode(json);
      var respData = RespData(errorCode: 0, data: map["resp"]);
      return respData;
    }).build();
    var response = await shttp.get('WeatherApi?city=$city');
    return Weather2.fromJson(response.data);
  }

}
