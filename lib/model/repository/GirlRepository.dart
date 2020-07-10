
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:roll_demo/bean/Girl.dart';
import 'package:roll_demo/bean/RespData.dart';
import 'package:roll_demo/net/HttpBuilder.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class GirlRepository {
  static String BASE_URL = "https://www.mzitu.com/";

  static Future<List<Girl>> fetchData(String path, int pageNum) async {
    Dio shttp = HttpBuilder().baseUrl(BASE_URL).converter((data){
      /*// Create a client transformer
      final Xml2Json myTransformer = Xml2Json();
      // Parse a simple XML string
      myTransformer.parse(data);
      var json;
      // Transform to JSON using Parker
      json = myTransformer.toParker();
      print('Parker');
      print('');
      print(json);
      var map = jsonDecode(json);*/
      final String fakeRefer = BASE_URL + path + "/"; //伪造 refer 破解防盗链
      List<Girl> girls = [];
      var document = parse(data);
      print(document.outerHtml);
      Element total = document.querySelectorAll("div.postlist")[0];
      List<Element> items = total.querySelectorAll("li");
      for (Element element in items) {
        String url = element.querySelectorAll("img")[0].attributes["data-original"];
        Girl girl = new Girl(url: url);
        girl.link = element.querySelectorAll("a[href]")[0].attributes["href"];
        girl.refer = fakeRefer;
        girls.add(girl);
      }
      var respData = RespData(errorCode: 0, data: girls);
      return respData;
    }).build();
    var response = await shttp.get('$path/page/$pageNum/');
//    return (response.data as List).map((i) => Girl.fromJson(i)).toList();
    return response.data;
  }
}