import 'package:roll_demo/twofriend/struct/user_info.dart';

/// 帖子内容
///
/// {
///   "id" : "string",
///   "title" : "string",
///   "summary" : "string",
///   "detailInfo" : "string",
///   "uid" : "string",
///   "userInfo" : "StructUserInfo",
///   "articleImage" : "string",
///   "likeNum" : "int",
///   "commentNum" : "int"
/// }
///
class StructContentDetail {
  final String id;
  /// 标题
  final String title;
  /// 简要
  final String summary;
  /// 主要内容
  final String detailInfo;
  final String uid;
  final UserInfoStruct userInfo;
  final String articleImage;
  final int likeNum;
  final int commentNum;

  StructContentDetail(this.id, this.title, this.summary, this.detailInfo, this.uid, this.likeNum, this.commentNum, this.articleImage, {this.userInfo});
}