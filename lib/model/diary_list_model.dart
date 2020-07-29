import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/model/ViewStateRefreshListModel.dart';

import 'ViewStateListModel.dart';
import 'db/database.dart';

/// 日记列表数据模型
class DiaryListModel extends ViewStateRefreshListModel<Diary> {

  @override
  Future<List<Diary>> loadData({int pageNum}) async {
    int offset = pageSize * pageNum;
    List<Diary> data = await DBProvider.db.getTasks(limit: pageSize, offset: offset);
    return data;
  }

}