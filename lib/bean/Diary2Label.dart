/// 日志和标签的关系
class Diary2Label {
  int id;
  int diaryId;
  int labelId;
  // 账号
  String account;

  ///存放在云端后拿到的云数据库Id,若[cloudId]为空，表示尚未上传到云端
  String uniqueId;

  // 已删除
  bool isDelete = false;

  Diary2Label({this.id, this.diaryId, this.labelId, this.account});

  Diary2Label.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.diaryId = json['diaryId'];
    this.labelId = json['labelId'];
    this.account = json['account'];
    this.uniqueId = json['uniqueId'];
    this.isDelete = json["isDelete"] == 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['diaryId'] = this.diaryId;
    data['labelId'] = this.labelId;
    data['account'] = this.account;
    data['uniqueId'] = this.uniqueId;
    data['isDelete'] = isDelete == true ? 1 : 0;
    return data;
  }
}