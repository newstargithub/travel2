import 'package:roll_demo/bean/Diary.dart';

import 'ViewStateListModel.dart';
import 'db/database.dart';

/// 日记列表数据模型
class DiaryListModel extends ViewStateListModel<Diary> {

  @override
  Future<List<Diary>> loadData() async {
    return await DBProvider.db.getAllTasks();
  }



}