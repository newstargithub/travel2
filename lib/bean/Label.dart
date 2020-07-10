import 'package:roll_demo/util/conmon_util.dart';
import 'package:roll_demo/util/date_util.dart';

/// 标签
class Label {
  String title;//非空唯一
  String account;//所属账号
  int id;

  ///存放在云端后拿到的云数据库Id,若[cloudId]为空，表示尚未上传到云端
  String uniqueId;

  ///是否需要在云端更新,true or false
  String needUpdateToCloud;

  /// UI展示是否选中
  bool selected = false;

  DateTime updateDate;

  Label({this.id, this.title, this.account});

  Label.fromJson(Map<String, dynamic> json) {    
    this.title = json['title'];
    this.id = json['id'];
    this.account = json['account'];
    this.account = json['account'];
    this.updateDate = DateUtil.parse(json['updateDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['account'] = this.account;
    data['updateDate'] = CommonUtil.formatDate(updateDate);
    return data;
  }

  static List<Label> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((e)=>Label.fromJson(e)).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Label &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Label{title: $title, account: $account, id: $id, uniqueId: $uniqueId, needUpdateToCloud: $needUpdateToCloud, selected: $selected, updateDate: $updateDate}';
  }


}
