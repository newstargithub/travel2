
/// 用户信息
///
/// {
///   "nickname" : "string",
///   "headerUrl" : "string",
///   "uid" : "string"
/// }
class UserInfoStruct {
  /// 用户的昵称
  final String nickname;
  /// 用户头像信息
  final String headerUrl;
  /// id
  final String uid;

  /// 默认构造函数
  UserInfoStruct(this.nickname, this.headerUrl, this.uid);
}