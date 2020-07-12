
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/bean/rich_text_data.dart';
import 'package:roll_demo/generated/i18n.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/model/db/database.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/date_util.dart';
import 'package:roll_demo/util/toast.dart';
/// 编辑日记数据模型
class DiaryModel extends ViewStateLoadModel<Diary>{

  int currentPosition = 0; //当前获取焦点的位置
  TextEditingController currentEditController;//当前获取焦点编辑框的控制器
  FocusNode currentFocusNode;

  /// 源数据
  Diary item;

  /// 编辑值
  String _id;

  String location = "";

  String weather = "";

  DateTime dateTime;

  List<Label> labelList = [];

  Color color;

  RichTextData textList = RichTextData()..initial();

  bool isInsert = true;//是新增

  bool isEdit = false;//在编辑状态

  get date => DateUtil.formatUpdateDate(dateTime);

  get labels => CommonUtil.appendString(labelList);

  get isCreate => item == null;

  DiaryModel(String _id) {
    this._id = _id;
  }

  @override
  Future<Diary> loadData() async {
     var diary;
     if(!CommonUtil.isEmpty(_id)) {
       diary= await getTask(_id);
     }
     if(diary != null) {
       this.item  = diary;
       dateTime = item.dateTime;
       weather = item.weather;
       location = item.location;
       labelList = item.labelList;
       textList = item.richTextData;
       color = item.color != null ? Color(item.color) : null;
     } else {
       isEdit = true;
       //默认设置时间为现在
       dateTime = DateTime.now();
     }
     return diary;
  }

  Future<List<Diary>> getAllTask(String id) async {
    return await DBProvider.db.getAllTasks();
  }

  Future<Diary> getTask(String id) async {
    var data = await DBProvider.db.getTaskById(id);
    debugPrint("getTask" + data.toString());
    return data;
  }

  Future<int> insertTask(Diary bean) async {
    return await DBProvider.db.insertTask(bean);
  }

  Future<int> updateTask(Diary bean) async {
    return await DBProvider.db.updateTask(bean);
  }

  void setDiary(Diary item) {
    this.item  = item;
    notifyListeners();
  }

  /// 新建成功
  void setSaveSuccess(BuildContext context, Diary bean) {
    isEdit = false;
    setDiary(bean);
    Toast.show(S.of(context).save_success);
  }

  /// 保存
  Future<int> saveDiary(BuildContext context, Diary bean) async {
    var result;
    if(item != null) {
      bean.id = item.id;
      bean.createTime = item.createTime;
      bean.account = item.account;
      bean.oldLabelList = item.labelList;
      result = await updateTask(bean);
    } else {
      result = await insertTask(bean);
      if(result > 0) {
        bean.id = result;
      }
    }
    return result;
  }

  /// 设置地址
  void setAddress(String address) {
    this.location = address;
    notifyListeners();
  }

  /// 设置天气
  void setWeather(String weather) {
    this.weather = weather;
    notifyListeners();
  }

  /// 设置时间日期
  void setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
    notifyListeners();
  }

  /// 设置标签列表
  void setLabels(List<Label> labels) {
    labelList = labels;
    notifyListeners();
  }

  /// 设置背景色
  void setBackgroundColor(Color color) {
    this.color = color;
    notifyListeners();
  }

  /// 设置在编辑状态
  void setEditState() {
    isEdit = true;
    notifyListeners();
  }

}