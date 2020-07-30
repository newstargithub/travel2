
import 'package:flutter/cupertino.dart';
import 'package:roll_demo/twofriend/struct/article_summary.dart';
import 'package:roll_demo/twofriend/struct/content_detail.dart';
import 'package:roll_demo/twofriend/struct/user_info.dart';
import 'package:roll_demo/twofriend/widgets/article_bottom_bar.dart';
import 'package:roll_demo/twofriend/widgets/article_like_bar.dart';
import 'package:roll_demo/twofriend/widgets/article_summary.dart';

/// 此为帖子描述类，包括了帖子UI中的所有元素
class ArticleCard extends StatelessWidget {
  /// 传入的用户信息
  final UserInfoStruct userInfo;
  /// 传入的帖子信息
  final StructContentDetail articleInfo;
  /// 构造函数
  const ArticleCard({Key key, this.userInfo, this.articleInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ArticleSummary(title: articleInfo.title,
            summary: articleInfo.summary,
            articleImage: articleInfo.articleImage),
        // 帖子的相关作者以及点赞评论信息
        Row(
          children: <Widget>[
            ArticleBottomBar(
                nickname: userInfo.nickname,
                headerImage: userInfo.headerUrl,
                commentNum: articleInfo.commentNum),
            ArticleLikeBar(articleId: articleInfo.id),
          ],
        )
      ],
    );
  }
}