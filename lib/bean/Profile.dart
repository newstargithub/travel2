import 'User.dart';
/// 配置信息
class Profile {
  // 账号信息，结构见"user.json"
  User user;
  // 登录用户的token(oauth)或密码
  String token;
  // 缓存策略信息，结构见"cacheConfig.json"
  String cache;
  // 最近一次的注销登录的用户名
  String lastLogin;
  // APP语言信息
  String locale;
  // 主题色值
  int theme;

  Profile({this.user, this.token, this.cache, this.lastLogin, this.locale, this.theme});

  Profile.fromJson(Map<String, dynamic> json) {    
    this.user = json['user'];
    this.token = json['token'];
    this.cache = json['cache'];
    this.lastLogin = json['lastLogin'];
    this.locale = json['locale'];
    this.theme = json['theme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['token'] = this.token;
    data['cache'] = this.cache;
    data['lastLogin'] = this.lastLogin;
    data['locale'] = this.locale;
    data['theme'] = this.theme;
    return data;
  }

}
