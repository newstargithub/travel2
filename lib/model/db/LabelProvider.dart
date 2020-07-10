import 'package:roll_demo/bean/Label.dart';
import 'package:sqflite/sqflite.dart';

final String tableLabel = 'Label';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class LabelProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        create table $tableLabel ( 
          $columnId integer primary key autoincrement, 
          $columnTitle text not null,
          $columnDone integer not null)
        ''');
      },);
  }

  Future<Label> insert(Label bean) async {
    bean.id = await db.insert(tableLabel, bean.toJson());
    return bean;
  }

  Future<Label> get(int id) async {
    List<Map> maps = await db.query(tableLabel,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Label.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableLabel, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Label bean) async {
    return await db.update(tableLabel, bean.toJson(),
        where: '$columnId = ?', whereArgs: [bean.id]);
  }

  Future close() async => db.close();

}