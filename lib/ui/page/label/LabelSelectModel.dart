
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/model/db/database.dart';
/// 选择标签数据模型
class LabelSelectModel extends ViewStateListModel<Label>{

  List<Label> _selectLabels;

  LabelSelectModel({List<Label> selectLabels}) {
    //新创建一个选中列表，不干预数据源列表
    this._selectLabels = selectLabels != null ? List.from(selectLabels) : [];
  }

  @override
  Future<List<Label>> loadData() async {
     var list = await DBProvider.db.getAllLabels();
     for(var item in list) {
       item.selected = _selectLabels.contains(item);
     }
     return list;
  }

  void toggle(Label item) {
    if(_selectLabels.contains(item)) {
      unSelectLabel(item);
    } else {
      selectLabel(item);
    }
  }

  void unSelectLabel(Label item) {
    _selectLabels.remove(item);
    item.selected = false;
    notifyListeners();
  }

  void selectLabel(Label item) {
    _selectLabels.add(item);
    item.selected = true;
    notifyListeners();
  }

  List<Label> get selectLabels => _selectLabels;

}