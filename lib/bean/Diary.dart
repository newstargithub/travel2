import 'dart:convert';

import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/bean/rich_text_data.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/date_util.dart';

import 'CustomTypeList.dart';

final String tableName = 'diary';
final String columnId = 'id';
final String columnContent = 'content';
final String columnIsDelete = 'isDelete';
final String columnDateTime = 'dateTime';
final String columnCreateTime = 'createTime';
final String columnUpdateTime = 'updateTime';
final String columnWeather = 'weather';
final String columnLocation = 'location';
final String columnAccount = 'account';
final String columnColor = 'color';

/// 日记
class Diary {
  int id = 0;
  // 已删除
  bool isDelete = false;
  // 内容
  String content;
  // 时间
  DateTime dateTime;
  // 创建时间
  DateTime createTime;
  // 更新时间
  DateTime updateTime;
  // 天气
  String weather;
  // 位置(经纬度?)
  String location;
  // 账号
  String account;
  // 标签(多对多 单独关系表记录)
  List<Label> labelList;

  //背景颜色
  int color;

  //富文本数据，来源于content
  RichTextData richTextData;

  //用于记录原来的标签数据
  List<Label> oldLabelList;

  //时间
  get date => DateUtil.formatUpdateDate(dateTime);

  //星期几
  String get weekday => DateUtil.getWeekday(dateTime)?? "";

  //时间段
  String get timeQuantum => DateUtil.getTimeQuantum(dateTime)?? "";

  //哪天
  String get day => dateTime != null ? "${dateTime.day}" : "";

  String get month => dateTime != null ? "${dateTime.month}" : "";

  String get year => dateTime != null ? "${dateTime.year}" : "";

  String get yearAndMonth => DateUtil.formatYearAndMonth(dateTime);

  //封面文字
  get envelopeText {
    if(richTextData == null) {
      return "";
    }
    for(CustomTypeList item in richTextData.list) {
      if(item.isText) {
        return item.data;
      }
    }
    return "";
  }

  //封面图片
  get envelopePic {
    if(richTextData == null) {
      return "";
    }
    for(CustomTypeList item in richTextData.list) {
      if(item.isImage) {
        return item.data;
      }
    }
    return "";
  }

  // 图片(一张还是几张)


  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
      columnIsDelete: isDelete == true ? 1 : 0,
      columnDateTime: CommonUtil.formatDate(dateTime),
      columnCreateTime: CommonUtil.formatDate(createTime),
      columnUpdateTime: CommonUtil.formatDate(updateTime),
      columnWeather: weather,
      columnLocation: location,
      columnAccount: account,
      columnColor: color
    };
    if (id != null && id != 0) {
      map[columnId] = id;
    }
    return map;
  }

  Diary();

  Diary.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    isDelete = map[columnIsDelete] == 1;
    dateTime = DateUtil.parse(map[columnDateTime]);
    createTime = DateUtil.parse(map[columnCreateTime]);
    updateTime = DateUtil.parse(map[columnUpdateTime]);
    weather = map[columnWeather];
    location = map[columnLocation];
    account = map[columnAccount];
    richTextData = RichTextData.fromJson(json.decode(content));
    color = map[columnColor];
  }

  static List<Diary> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((e) => Diary.fromMap(e)).toList();
  }

  @override
  String toString() {
    return 'Diary{id: $id, isDelete: $isDelete, content: $content, dateTime: $dateTime, createTime: $createTime, updateTime: $updateTime, weather: $weather, location: $location, account: $account, labelList: $labelList}';
  }


}