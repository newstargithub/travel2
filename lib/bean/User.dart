/// 用户
class User {
  String email;//邮箱
  String icon;//头像
  String nickname;//昵称
  String password;//密码
  String publicName;
  String token;//令牌
  String username;//用户名
  bool admin;//是管理员
  int id;
  int type;
  String slogan;//个性签名

  User({this.email, this.icon, this.nickname, this.password, this.publicName, this.token, this.username, this.admin, this.id, this.type, this.slogan});

  /// 用于从一个map构造出一个 User实例
  User.fromJson(Map<String, dynamic> json) {
    this.email = json['email'];
    this.icon = json['icon'];
    this.nickname = json['nickname'];
    this.password = json['password'];
    this.publicName = json['publicName'];
    this.token = json['token'];
    this.username = json['username'];
    this.admin = json['admin'];
    this.id = json['id'];
    this.type = json['type'];
    this.slogan = json['slogan'];
  }

  /// 将User实例转化为一个map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['icon'] = this.icon;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['publicName'] = this.publicName;
    data['token'] = this.token;
    data['username'] = this.username;
    data['admin'] = this.admin;
    data['id'] = this.id;
    data['type'] = this.type;
    data['slogan'] = this.slogan;
    return data;
  }



}
