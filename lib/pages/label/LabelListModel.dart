
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/model/db/database.dart';

class LabelListModel extends ViewStateListModel<Label>{

  bool _isEdit = false;

  @override
  Future<List<Label>> loadData() {
    return DBProvider.db.getAllLabels();
  }

  void insertLabel(String title) async {
    Label bean = Label(title: title);
    await DBProvider.db.insertLabel(bean);
    refresh();
  }

  void deleteLabel(int id) async {
    await DBProvider.db.deleteLabel(id);
    refresh();
  }

  void switchEditModel() {
    _isEdit = !_isEdit;
    debugPrint("switchEditModel");
    notifyListeners();
  }

  bool get isEdit => _isEdit;

  void updateLabel(Label bean) async {
    await DBProvider.db.updateLabel(bean);
    refresh();
  }

}