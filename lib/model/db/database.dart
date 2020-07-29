
import 'package:flutter/material.dart';
import 'package:roll_demo/bean/Diary.dart';
import 'package:roll_demo/bean/Diary2Label.dart';
import 'package:roll_demo/bean/Label.dart';
import 'package:roll_demo/config/keys.dart';
import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/sp_util.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  /// 日记表
  static const TABLE_DIARY = "Diary";
  /// 标签表
  static const TABLE_LABEL = "Label";
  /// 关系表
  static const TABLE_DIARY_LABEL = "Diary_Label";

  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var dataBasePath = await getDatabasesPath();
    String path = "${dataBasePath}todo.db";
    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {

      },
      onCreate: (Database db, int version) async {
        print("当前版本:$version");
        await db.execute("CREATE TABLE " + TABLE_DIARY + "("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "account TEXT,"
            "content TEXT NOT NULL,"
            "isDelete INTEGER,"
            "createTime TEXT,"
            "updateTime TEXT,"
            "dateTime TEXT,"
            "weather TEXT,"
            "location TEXT,"
            "color INTEGER,"
            "uniqueId TEXT,"
            "needUpdateToCloud INTEGER"
            ")"
        );
        await db.execute("CREATE TABLE "+ TABLE_LABEL + "("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "account TEXT,"
            "title TEXT NOT NULL UNIQUE,"
            "uniqueId TEXT,"
            "updateDate TEXT"
            ")");
        await db.execute("CREATE TABLE "+ TABLE_DIARY_LABEL + "("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "diaryId INTEGER,"
            "labelId INTEGER,"
            "account TEXT,"
            "uniqueId TEXT,"
            "isDelete INTEGER,"
            "foreign key(diaryId) references " + TABLE_DIARY + "(id) "
            "on update cascade " //# 同步更新
            "on delete cascade," //# 同步删除
            "foreign key(labelId) references " + TABLE_LABEL + "(id) "
            "on update cascade " //# 同步更新
            "on delete cascade" //# 同步删除
            ")");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async{
        print("新版本:$newVersion");
        print("旧版本:$oldVersion");
        //数据库升级的代码不太适合用if-else判断具体版本去写适配策略，版本一多适配代码就乱了。建议用none break的switch-case去写
        switch(oldVersion) {
          case 2:
            // await db.execute("ALTER TABLE " + TABLE_DIARY + " ADD COLUMN color INTEGER");
            break;
          case 3:
            // await db.execute("ALTER TABLE TodoList ADD COLUMN uniqueId TEXT");
            // await db.execute("ALTER TABLE TodoList ADD COLUMN needUpdateToCloud TEXT");
            break;
        }
      },
    );
    ///注意，上面创建表的时候最后一行不能带逗号
  }

  ///判断表是否存在
  isTableExits(String tableName) async {
    final db = await database;
    var res = await db.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res!=null && res.length >0;
  }

  ///关闭
   close() {
    _database?.close();
    _database = null;
  }

  ///创建一项任务
  Future<int> insertTask(Diary bean) async {
    final db = await database;
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    bean.createTime = bean.updateTime = DateTime.now();
    bean.account = theAccount;
    //开启事务，不要在事务中使用数据库对象，这将导致死锁！
    return await db.transaction<int>((Transaction txn) async {
      var result = await txn.insert(TABLE_DIARY, bean.toMap());
      if(result > 0) {
        bean.id = result;
        List<Label> labelList = bean.labelList;
        // 警告，在事务处理期间，在事务处理被提交之前不会提交批处理
        // 提交，但实际提交将在提交事务时发生，但是此事务中的数据是可用的
        // 批量提交
        var batch = txn.batch();
        batchInsertDiaryLabel(batch, bean, theAccount, labelList);
        batch.commit();
      }
      return result;
    }, exclusive: false);
  }

  /// 批量插入
  void batchInsertDiaryLabel(Batch batch, Diary bean, String theAccount, List<Label> labelList) {
    if(!CommonUtil.isEmptyList(labelList)) {
      Diary2Label dlBean = Diary2Label(diaryId: bean.id, account: theAccount);
      for(Label item in labelList) {
        dlBean.labelId = item.id;
        batch.insert(TABLE_DIARY_LABEL, dlBean.toJson());
      }
    }
  }

  /// 批量删除
  void batchDeleteDiaryLabel(Batch batch, Diary bean, List<Label> labelList) {
    if(!CommonUtil.isEmptyList(labelList)) {
      for(Label item in labelList) {
        batch.delete(TABLE_DIARY_LABEL, where: "diaryId = ? and labelId = ?", whereArgs: [bean.id, item.id]);
      }
    }
  }

  /// 批量更新
  void batchUpdateDiaryLabel(Batch batch, Diary bean, String theAccount, List<Label> labelList) {
    if(!CommonUtil.isEmptyList(labelList)) {
      Diary2Label dlBean = Diary2Label(diaryId: bean.id, account: theAccount);
      for(Label item in labelList) {
        dlBean.labelId = item.id;
        batch.update(TABLE_DIARY_LABEL, dlBean.toJson(), where: "diaryId = ? and labelId = ?", whereArgs: [bean.id, item.id]);
      }
    }
  }

  /// 查询所有任务
  Future<List<Diary>> getAllTasks({String account}) async {
    final db = await database;
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    var list = await db.query(TABLE_DIARY,
        where: "account = ?" ,
        whereArgs: [account ?? theAccount]);
    List<Diary> beans = [];
    beans.addAll(Diary.fromMapList(list));
    return beans;
  }

  /// 分页查询任务
  /// select * from Diary where account = default order by columnDateTime asc limit 1 to 20
  /// @param limit 查询条数
  /// @param offset 起始位置
  Future<List<Diary>> getTasks({String account, int limit = 20, int offset = 0}) async {
    final db = await database;
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    String orderBy = columnDateTime + " DESC";
    var list = await db.query(TABLE_DIARY,
        where: "account = ?" ,
        whereArgs: [account ?? theAccount],
      orderBy: orderBy,
      limit: limit,
      offset: offset
    );
    List<Diary> beans = [];
    beans.addAll(Diary.fromMapList(list));
    return beans;
  }

  /// 查询所有任务
  Future<List<Diary>> getHistoryTasks({String account}) async {
    final db = await database;
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
//    String groupBy = "";
    String orderBy = "$columnDateTime desc";
    var list = await db.query(TABLE_DIARY,
      where: "account = ?",
      whereArgs: [account ?? theAccount],
//      groupBy: groupBy,
      orderBy: orderBy
    );
    List<Diary> beans = Diary.fromMapList(list);
    return beans;
  }

  /// 模糊查询所有任务
  Future<List<Diary>> searchTasks({String keyWord, String account}) async {
    try {
      final db = await database;
      final theAccount =
          await SpUtil.getString(Keys.account) ?? "default";
      String orderBy = "$columnDateTime desc";
     /* var list = await db.query(TABLE_DIARY,
          where: "account = '$theAccount' and ("
              " (content like '%$keyWord%')"
              " or (weather like '%$keyWord%')"
              " or (location like '%$keyWord%')"
              ")",
//          whereArgs: [account ?? theAccount, keyWord, keyWord, keyWord],
          orderBy: orderBy
      );*/
      // 左连接
      String sql = "select distinct D.* from Diary D "
         "left join Diary_Label T on D.id = T.diaryId "
         "left join Label L on T.labelId = L.id "
          "WHERE D.account = '$theAccount' and ((D.content like '%$keyWord%') or (D.weather like '%$keyWord%') or (D.location like '%$keyWord%') or L.title like '%$keyWord%') "
          "ORDER BY dateTime desc ";
      debugPrint("searchTasks sql:$sql");
      var list = await db.rawQuery(sql);
      List<Diary> beans = Diary.fromMapList(list);
      return beans;
    } catch(e) {
      print('sql异常:$e');
      return null;
    }
  }

  /// 更新任务
  Future<int> updateTask(Diary bean) async {
    //开启事务
    try {
      bean.updateTime = DateTime.now();
      final db = await database;
      final theAccount =
          await SpUtil.getString(Keys.account) ?? "default";
      return await db.transaction<int>((Transaction txn) async {
        var result =  await txn.update(TABLE_DIARY, bean.toMap(),
            where: "id = ? ", whereArgs: [bean.id]);
        if(result > 0) {
          Set<Label> labelSet = bean.labelList.toSet();
          //增加和删除标签
          Set<Label> oldLabelSet = bean.oldLabelList?.toSet();
          Set insertList, deleteList;
          if(oldLabelSet != null) {
            var intersectionSet = oldLabelSet.intersection(labelSet);//交集
            deleteList = oldLabelSet.difference(intersectionSet);
            insertList = labelSet.difference(intersectionSet);
          } else {
            deleteList = null;
            insertList = labelSet;
          }
          debugPrint("deleteList：" + deleteList?.toString());
          debugPrint("insertList：" + insertList?.toString());
          //批量提交
          var batch = txn.batch();
          batchInsertDiaryLabel(batch, bean, theAccount, insertList?.toList(growable: false));
          batchDeleteDiaryLabel(batch, bean, deleteList?.toList(growable: false));
          batch.commit();
        }
        return result;
      }, exclusive: true);
    } catch (e) {
       print('sql异常:$e');
       return -1;
    }
  }

  /// 删除任务
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(TABLE_DIARY, where: "id = ?", whereArgs: [id]);
  }

  ///批量更新任务
  Future updateTasks(List<Diary> taskBeans) async{
    final db = await database;
    final batch = db.batch();
    for (var task in taskBeans) {
      batch.update(TABLE_DIARY, task.toMap(),
          where: "id = ?", whereArgs: [task.id]);
    }
    final results = await batch.commit();
    print("批量更新结果:$results");
  }

  ///批量创建任务
  Future createTasks(List<Diary> taskBeans) async{
    final db = await database;
    final batch = db.batch();
    for (var task in taskBeans) {
      batch.insert(TABLE_DIARY, task.toMap());
    }
    final results = await batch.commit();
    print("批量插入结果:$results");
  }

  ///根据[uniqueId]查询一项任务
  Future<List<Diary>> getTaskByUniqueId(String uniqueId) async{
    final db = await database;
    var tasks = await db.query(TABLE_DIARY,
        where: "uniqueId = ?" ,
        whereArgs: [uniqueId]);
    if(tasks.isEmpty) return null;
    return Diary.fromMapList(tasks);
  }

  ///根据[Id]查询一项任务
  Future<Diary> getTaskById(String id) async{
    final db = await database;
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    List<Map<String, dynamic>> tasks = await db.query(TABLE_DIARY,
        where: "id = ? and account = ?" ,
        whereArgs: [id, theAccount]);
    if(tasks.isEmpty) return null;
    // get the first record
    Map<String, dynamic> mapRead = tasks.first;
    Diary bean = Diary.fromMap(mapRead);
    // 获取标签列表
    bean.labelList = await getDiary2Labels(bean);
    return bean;
  }

  ///批量更新账号
  Future updateAccount(String account) async{
    final tasks = await getAllTasks(account: "default");
    List<Diary> newTasks = [];
    for (var task in tasks) {
      if(task.account == "default"){
        task.account = account;
        newTasks.add(task);
      }
    }
    print("更新结果:$newTasks   原来:$tasks");
    updateTasks(newTasks);
  }

  ///通过加上百分号，进行模糊查询
  Future<List<Diary>> queryTask(String query) async {
    final db = await database;
    final account =
        await SpUtil.getString(Keys.account) ?? "default";
    var list = await db.query(TABLE_DIARY,
        where: "account = ? AND (taskName LIKE ? "
            "OR detailList LIKE ? "
            "OR startDate LIKE ? "
            "OR deadLine LIKE ?)",
        whereArgs: [
          account,
          "%$query%",
          "%$query%",
          "%$query%",
          "%$query%",
        ]);
    List<Diary> beans = [];
    beans.addAll(Diary.fromMapList(list));
    return beans;
  }


  ///###################Label#####################
  ///创建一标签
  Future insertLabel(Label bean) async {
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    bean.account = theAccount;
    final db = await database;
    bean.id = await db.insert(TABLE_LABEL, bean.toJson());
  }

  ///查询所有标签
  Future<List<Label>> getAllLabels({String account}) async {
    final db = await database;
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    var list = await db.query(TABLE_LABEL,
        where: "account = ?" ,
        whereArgs: [account ?? theAccount]);
    List<Label> beans = Label.fromMapList(list);
    return beans;
  }

  /// 更新标签
  Future updateLabel(Label bean) async {
    bean.updateDate = DateTime.now();
    final db = await database;
    await db.update(TABLE_LABEL, bean.toJson(),
        where: "id = ?", whereArgs: [bean.id]);
  }

  /// 删除标签
  Future deleteLabel(int id) async {
    final db = await database;
    db.delete(TABLE_LABEL, where: "id = ?", whereArgs: [id]);
  }

  ///###################Diary2Label#####################
  Future insertDiary2Label(Diary2Label bean) async {
    final theAccount =
        await SpUtil.getString(Keys.account) ?? "default";
    bean.account = theAccount;
    final db = await database;
    bean.id = await db.insert(TABLE_DIARY_LABEL, bean.toJson());
  }

  Future getDiary2Labels(Diary bean) async {
    final db = await database;
    var list = await db.rawQuery("SELECT label.* FROM $TABLE_LABEL as label, $TABLE_DIARY_LABEL as d2l WHERE diaryId = ${bean.id} and label.id = d2l.labelId");
    List<Label> beans = Label.fromMapList(list);
    debugPrint("getDiary2Labels：" + beans.toString());
    return beans;
  }



}