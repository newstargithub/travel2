
import 'package:roll_demo/twofriend/struct/user_info.dart';

/// 评论
///
/// {
///   "userInfo" : "StructUserInfo",
///   "comment" : "string"
/// }
class StructCommentInfo {
  /// 用户信息
  final UserInfoStruct userInfo;
  /// 评论内容
  final String comment;

  /// 构造函数
  StructCommentInfo(this.userInfo, this.comment);

}