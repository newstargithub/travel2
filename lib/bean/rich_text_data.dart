import 'package:flutter/cupertino.dart';
import 'package:roll_demo/bean/CustomTypeList.dart';

/// 图文混排列表
class RichTextData {

  List<CustomTypeList> list = [];

  RichTextData({List<CustomTypeList> list}) {
    if(list != null) {
      this.list = list;
    }
  }

  void initial(){
    if(list.length > 0) {
      throw UnsupportedError("列表已被初始化过");
    }
    list.add(CustomTypeList());
  }

  void initialList(List<CustomTypeList> textPicList){
    if(list.length > 0) {
      throw UnsupportedError("列表已被初始化过");
    }
    list = List.from(textPicList);
  }

  /// 插入一个
  /// selectText 删除掉
  void insertOne(int currentPosition, String beforeText, String selectText,
      String afterText, CustomTypeList t) {
    debugPrint("insertOne：$currentPosition $beforeText $selectText $afterText $t");
    if(list.length == 0) throw UnsupportedError("列表尚未初始化");
    if (currentPosition < 0) throw ArgumentError("数字[${currentPosition}]不合法");
    if (currentPosition >= list.length) throw ArgumentError("[${currentPosition}]数组越界了");
    if(t == null) throw ArgumentError("插入数据不能为空");
    if(beforeText.isEmpty) {
      list.insert(currentPosition, t);
    } else {
      list[currentPosition].data = beforeText;
      list.insert(currentPosition + 1, t);
      list.insert(currentPosition + 2, new CustomTypeList(data: afterText));
    }
  }

  void insert(int currentPosition, String beforeText, String selectText, String afterText, List<CustomTypeList> listOld){
    if(list.length == 0) throw UnsupportedError("列表尚未初始化");
    if (currentPosition < 0) throw ArgumentError("数字[${currentPosition}]不合法");
    if (currentPosition >= list.length) throw ArgumentError("[${currentPosition}]数组越界了");
    if(listOld == null) throw ArgumentError("插入列表不能为空");
    if(listOld.length == 0 || listOld.isEmpty) return;
    list[currentPosition].data = beforeText;
    for(int i = 0; i < listOld.length; i++) {
      var item = listOld[i];
      list.insert(currentPosition + 1 + i, item);
    }
    list.insert(currentPosition + 1 + listOld.length, new CustomTypeList(data: afterText));
  }

  void remove(int currentPosition) {
    if(list.length == 0) throw UnsupportedError("列表尚未初始化");
    if (currentPosition >= list.length) throw ArgumentError("长度超过了呀！");
//    if (currentPosition <= 0) throw Exception("不应该删除第一个！");
    if (currentPosition == 0) {
      var current = list[currentPosition];
      if(!current.isText) {
        list.removeAt(currentPosition);
      }
    } else if (currentPosition < list.length - 1) {
      var next = list[currentPosition + 1];
      var pre = list[currentPosition - 1];
      if(!next.isText || !pre.isText) {
        list.removeAt(currentPosition);
      } else {
        String afterText = next.data;
        pre.data += afterText;
        list.removeRange(currentPosition, currentPosition + 2);
      }
    } else if (currentPosition == list.length - 1) {
      throw UnsupportedError("不应该删除的是最后一个！");
    }
  }

  int get size => list.length;

  void printListText(){
    for(CustomTypeList t in list){
      print("${t.data} \n");
    }
  }

  @override
  String toString() {
    return 'TextPicList{_textPicList: $list}';
  }

  RichTextData.fromJson(Map<String, dynamic> map) {
    var data = map['list'];
    list = data.map<CustomTypeList>((e)=>
        CustomTypeList.fromJson(e)
    ).toList();
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic> {
        'list': list.map((CustomTypeList e)=>e.toJson()).toList(),
      };

}
