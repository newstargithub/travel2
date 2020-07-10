
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/model/ViewStateListModel.dart';
import 'package:roll_demo/model/db/database.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/dialog_util.dart';
import 'package:roll_demo/util/toast.dart';

class SearchModel extends ViewStateListModel<Diary> {

  String keyWord;


  SearchModel(this.keyWord);

  @override
  Future<List<Diary>> loadData() async {
    List<Diary> list;
    if(CommonUtil.isEmpty(keyWord)) {
      list = await DBProvider.db.getHistoryTasks();
    } else {
      list = await DBProvider.db.searchTasks(keyWord: keyWord);
    }
    debugPrint("搜索查询结果$list");
    return list;
  }

  Future<List<Diary>> search(String keyWord) async {
    this.keyWord = keyWord;
    return await initData();
  }


}